// create nat instance from ami

resource  "aws_instance" "nat_instance" {
  ami   = "ami-0541ea7d"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.public_subnet.id}"
  associate_public_ip_address = true
  source_dest_check = false
  private_ip  = "192.168.0.20"
  security_groups = ["${aws_security_group.nat_instance_sg.id}"]
  key_name  = "test-run"

  tags {
    Name =  "nat_instance_test"
  }
}

resource "aws_eip" "nat_eip" {
  vpc                       = true
  instance                  = "${aws_instance.nat_instance.id}"
  associate_with_private_ip = "192.168.0.20"
}

