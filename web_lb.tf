// Create target group for web_client loadbalancer
resource "aws_lb_target_group" "web_lb_tg" {
  vpc_id      = "${aws_vpc.cp_vpc.id}"
  name        = "web-lb-target-group"
  port        = 80
  protocol    = "HTTP"
}

// Create loadbalancer for web instance
resource "aws_lb" "web_lb" {
  name               = "web-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.web_sg.id}"]
  subnets            = ["${aws_subnet.public_subnet.id}","${aws_subnet.public_subnet_zone2.id}"]
  enable_deletion_protection = false

  tags {
    Name = "web_lb"
  }
}

// listener for loadbalancer
resource "aws_lb_listener" "web" {
  load_balancer_arn = "${aws_lb.web_lb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.web_lb_tg.arn}"
    type             = "forward"
  }
}

// register target group
resource "aws_lb_target_group_attachment" "web_tg_attachment" {
  target_group_arn = "${aws_lb_target_group.web_lb_tg.arn}"
  target_id        = "${aws_instance.web_instance.id}"
  port             = 80
}