/*====
VPC's Default Security Group
======*/
resource "aws_security_group" "default" {
  name        = "Hackathon-default-sg"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = "${aws_vpc.vpc.id}"
  depends_on  = ["aws_vpc.vpc"]

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    self      = true
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    self      = true
  }
}


/* security group for ALB */
resource "aws_security_group" "lb_sg" {
  name        = "Hackathon-lb-sg"
  description = "Allow HTTP from Anywhere into ALB"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "Hackathon-lb-sg"
  }
}


/* Traffic to the ECS cluster should only come from the ALB */
resource "aws_security_group" "ecs_tasks" {
  vpc_id      = "${aws_vpc.vpc.id}"
  name        = "Hackathon-ecs-task-sg"
  description = "Allow inbound access from the ALB only"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    security_groups = ["${aws_security_group.lb_sg.id}"]
  }

  tags {
    Name        = "Hackathon-ecs-service-sg"
  }
}
