// Create target group for api loadbalancer
resource "aws_lb_target_group" "api_lb_tg" {
  vpc_id      = "${aws_vpc.cp_vpc.id}"
  name        = "api-lb-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
}

// Create loadbalancer for api instance
resource "aws_lb" "api_lb" {
  name               = "api-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.web_sg.id}"]
  subnets            = ["${aws_subnet.public_subnet.id}","${aws_subnet.public_subnet_zone2.id}"]
  enable_deletion_protection = false

  tags {
    Name = "api_lb"
  }
}

// listener for loadbalancer
resource "aws_lb_listener" "api" {
  load_balancer_arn = "${aws_lb.api_lb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.api_lb_tg.arn}"
    type             = "forward"
  }
}

// register target group
resource "aws_lb_target_group_attachment" "api_tg_attachment" {
  target_group_arn = "${aws_lb_target_group.api_lb_tg.arn}"
  target_id        = "192.168.0.5"
  port             = 80
}