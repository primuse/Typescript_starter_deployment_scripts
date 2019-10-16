/*====
App Load Balancer
======*/

resource "aws_alb_target_group" "alb_target_group" {
  name        = "hackathon-alb-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "ip"

  lifecycle {
    create_before_destroy = true
  }
  depends_on = [aws_alb.alb_hackathon]
  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "20"
    path                = "/"
    unhealthy_threshold = "2"
  }
}

resource "aws_alb" "alb_hackathon" {
  name            = "hackathon-alb"
  subnets         = aws_subnet.public_subnet.*.id
  security_groups = [aws_security_group.lb_sg.id]

  tags = {
    Name = "hackathon-alb"
  }
}

resource "aws_alb_listener" "hackathon" {
  load_balancer_arn = aws_alb.alb_hackathon.arn
  port              = 80
  protocol          = "HTTP"
  depends_on        = [aws_alb_target_group.alb_target_group]

  default_action {
    target_group_arn = aws_alb_target_group.alb_target_group.arn
    type             = "forward"
  }
}

