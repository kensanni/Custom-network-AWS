// Get more-recipes-database ami

data "aws_ami" "database" {
  most_recent = true

  filter {
    name = "name"
    values = ["More-recipes-database *"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["753379358044"]
}

// create database instance from ami

resource  "aws_instance" "database_instance" {
  ami   = "${data.aws_ami.database.id}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.private_subnet.id}"
  associate_public_ip_address = false
  private_ip  = "192.168.0.10"
  security_groups = ["${aws_security_group.db_api_sg.id}"]
  key_name  = "test-run"

  tags {
    Name =  "database_instance_test"
  }
}