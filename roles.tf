data "aws_iam_policy_document" "ecs_task_execution_role" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# ECS task execution role
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "ecs_task_execution_role"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_task_execution_role.json}"
}

# ECS task execution role policy attachment
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = "${aws_iam_role.ecs_task_execution_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS auto scale role data
data "aws_iam_policy_document" "ecs_auto_scale_role" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["application-autoscaling.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_auto_scale_role" {
  name               = "Hackathon_ecs_autoscale_role"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_auto_scale_role.json}"
}

resource "aws_iam_role_policy_attachment" "ecs_auto_scale_role" {
  role       = "${aws_iam_role.ecs_auto_scale_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole"
}