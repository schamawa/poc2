resource "aws_lb_target_group" "test-target-group" {
  health_check {
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  name        = "test-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.test_vpc.id
}


resource "aws_lb_target_group_attachment" "test-alb-target-group-attachment1" {
  target_group_arn = "${aws_lb_target_group.test-target-group.arn}"
  target_id        = aws_instance.test_ec2.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "test-alb-target-group-attachment2" {
  target_group_arn = "${aws_lb_target_group.test-target-group.arn}"
  target_id        = aws_instance.test1_ec2.id
  port             = 80
}


resource "aws_lb" "test-aws-alb" {
  name     = "test-test-alb"
  internal = false

  security_groups = [aws_security_group.test_sg1.id]

  subnets = [aws_subnet.subnet_pub1.id, aws_subnet.subnet_pub2.id]

  tags = {
    Name = "test-alb"
  }

  ip_address_type    = "ipv4"
  load_balancer_type = "application"
}


resource "aws_lb_listener" "test-alb-listner" {
  load_balancer_arn = "${aws_lb.test-aws-alb.arn}"
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.test-target-group.arn}"
  }
}

