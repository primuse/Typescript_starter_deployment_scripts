/*====
ECR repository to store our Docker images
======*/
resource "aws_ecr_repository" "hackathon" {
  name = "hackathon-repo"
}

/*====
ECS cluster
======*/
resource "aws_ecs_cluster" "hackathon_cluster" {
  name = "Hackathon-ecs-cluster"
}

/*====
ECS task definitions
======*/

/* the task definition for the app service */
data "template_file" "app_task" {
  template = "${file("./tasks/app.json")}"

  vars {
    image           = "${aws_ecr_repository.hackathon.repository_url}"
    mongodb_uri     = "${var.mongodb_uri}"
    session_secret  = "${var.session_secret}"
    facebook_id     = "${var.facebook_id}"
    facebook_secret = "${var.facebook_secret}"
    log_group       = "${aws_cloudwatch_log_group.hackathon.name}"
    aws_region     =  "${var.region}"
  }
}

resource "aws_ecs_task_definition" "app" {
  family                   = "hackathon_app"
  container_definitions    = "${data.template_file.app_task.rendered}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = "${aws_iam_role.ecs_task_execution_role.arn}"
  task_role_arn            = "${aws_iam_role.ecs_task_execution_role.arn}"
}

/*====
ECS service
======*/

resource "aws_ecs_service" "app" {
  name            = "hackathon-app"
  task_definition = "${aws_ecs_task_definition.app.arn}"
  desired_count   = "${var.app_count}"
  launch_type     = "FARGATE"
  cluster =       "${aws_ecs_cluster.hackathon_cluster.id}"
  depends_on      = ["aws_iam_role_policy_attachment.ecs_task_execution_role"]

  network_configuration {
    security_groups = ["${aws_security_group.ecs_tasks.id}"]
    subnets         = ["${aws_subnet.private_subnet.*.id}"]
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.alb_target_group.arn}"
    container_name   = "app"
    container_port   = "${var.app_port}"
  }

  depends_on = ["aws_alb_target_group.alb_target_group"]
}
