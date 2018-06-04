data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = ["more-recipes*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["753379358044"]
}

resource "aws_instance" "web_instance" {
  ami   = "${data.aws_ami.ubuntu.id}"
  user_data     = "${file("userdata")}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.public_subnet.id}"
  associate_public_ip_address = true
  private_ip  = "192.168.0.24"
  security_groups = ["${aws_security_group.web_sg.id}"]
  key_name  = "test-run"

  tags {
    Name  = "web_instance_test"
  }
}
