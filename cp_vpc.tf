// cloud provider

provider "aws" {
  access_key  = "${var.access_key}"
  secret_key  = "${var.secret_key}"
  region      = "${var.region}"
}

// create vpc
resource "aws_vpc" "cp_vpc" {
  cidr_block        = "192.168.0.0/21"
  instance_tenancy  = "default"

  tags {
    Name = "cp_vpc"
  }
}


// private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id              = "${aws_vpc.cp_vpc.id}"
  cidr_block          = "192.168.0.0/28"
  availability_zone   = "us-west-2b"

  tags  {
    Name = "private subnet cp"
  }
}

// public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id              = "${aws_vpc.cp_vpc.id}"
  cidr_block          = "192.168.0.16/28"
  availability_zone   = "us-west-2b"

  tags  {
    Name = "public subnet cp"
  }
}

// public subnet in a different zone
resource "aws_subnet" "public_subnet_zone2" {
  vpc_id              = "${aws_vpc.cp_vpc.id}"
  cidr_block          = "192.168.0.32/28"
  availability_zone   = "us-west-2c"

  tags  {
    Name = "public subnet cp zone2"
  }
}

// route table for public subnet
resource "aws_route_table" "cp_rt" {
  vpc_id  = "${aws_vpc.cp_vpc.id}"

  tags {
    Name  = "cp_route_table_pub"
  }
}

// route table for private subnet
resource "aws_route_table" "cp_rt_priv" {
  vpc_id  = "${aws_vpc.cp_vpc.id}"

  tags {
    Name  = "cp_route_table_priv"
  }
}

// Create an internet gateway for VPC to send traffic out
resource "aws_internet_gateway" "cp_gateway" {
  vpc_id  = "${aws_vpc.cp_vpc.id}"

  tags {
    Name = "cp_internet_gateway"
  }
}

// edit route table to include internet gateway
resource "aws_route" "cp_rt" {
  gateway_id              = "${aws_internet_gateway.cp_gateway.id}"
  route_table_id          = "${aws_route_table.cp_rt.id}"
  destination_cidr_block  = "0.0.0.0/0"
}

// edit private route table to include nat instance
resource "aws_route" "cp_nat_instance" {
  instance_id             = "${aws_instance.nat_instance.id}"
  route_table_id          = "${aws_route_table.cp_rt_priv.id}"
  destination_cidr_block  = "0.0.0.0/0"
}

// public subnet association with route table
resource "aws_route_table_association" "cp_public" {
  subnet_id       = "${aws_subnet.public_subnet.id}"
  route_table_id  = "${aws_route_table.cp_rt.id}"
}

// private subnet association with route table
resource "aws_route_table_association" "cp_private" {
  subnet_id       = "${aws_subnet.private_subnet.id}"
  route_table_id  = "${aws_route_table.cp_rt_priv.id}"
}