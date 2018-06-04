resource  "aws_instance" "api_instance" {
  ami   = "ami-43581c3b"
  instance_type = "t2.micro"
  user_data     = "${file("api_data")}"
  subnet_id = "${aws_subnet.private_subnet.id}"
  associate_public_ip_address = false
  private_ip  = "192.168.0.5"
  security_groups = ["${aws_security_group.db_api_sg.id}"]
  key_name  = "test-run"

  tags {
    Name =  "api_instance_test"
  }
}
