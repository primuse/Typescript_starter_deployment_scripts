resource "aws_s3_bucket" "source" {
  bucket        = "primuse"
  acl           = "private"
}

resource "aws_iam_role" "codepipeline_role" {
  name = "codepipeline-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline_policy"
  role = "${aws_iam_role.codepipeline_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:List*",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.source.arn}",
        "${aws_s3_bucket.source.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    },
    {
      "Action": [
        "ecs:*",
        "events:DescribeRule",
        "events:DeleteRule",
        "events:ListRuleNamesByTarget",
        "events:ListTargetsByRule",
        "events:PutRule",
        "events:PutTargets",
        "events:RemoveTargets",
        "iam:ListAttachedRolePolicies",
        "iam:ListInstanceProfiles",
        "iam:ListRoles",
        "logs:CreateLogGroup",
        "logs:DescribeLogGroups",
        "logs:FilterLogEvents"
      ],
      "Resource": "*",
      "Effect": "Allow"
    },
    {
      "Action": "iam:PassRole",
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Condition": {
        "StringLike": {
          "iam:PassedToService": "ecs-tasks.amazonaws.com"
        }
      }
    },
    {
      "Action": "iam:PassRole",
      "Effect": "Allow",
      "Resource": [
        "arn:aws:iam::*:role/ecsInstanceRole*"
      ],
      "Condition": {
        "StringLike": {
          "iam:PassedToService": [
            "ec2.amazonaws.com",
            "ec2.amazonaws.com.cn"
          ]
        }
      }
    },
    {
      "Action": "iam:PassRole",
      "Effect": "Allow",
      "Resource": [
        "arn:aws:iam::*:role/ecsAutoscaleRole*"
      ],
      "Condition": {
        "StringLike": {
          "iam:PassedToService": [
            "application-autoscaling.amazonaws.com",
            "application-autoscaling.amazonaws.com.cn"
          ]
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": "iam:CreateServiceLinkedRole",
      "Resource": "*",
      "Condition": {
        "StringLike": {
          "iam:AWSServiceName": [
            "ecs.amazonaws.com",
            "spot.amazonaws.com",
            "spotfleet.amazonaws.com"
          ]
        }
      }
    }
  ]
}
EOF
}

/*
/* CodeBuild
*/
resource "aws_iam_role" "codebuild_role" {
  name               = "codebuild-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codebuild_policy" {
  name        = "codebuild-policy"
  role        = "${aws_iam_role.codebuild_role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "ecr:GetAuthorizationToken",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload",
        "ecr:BatchCheckLayerAvailability",
        "ecr:PutImage",
        "ecs:RunTask",
        "iam:PassRole"
      ]
    },
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:List*",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.source.arn}",
        "${aws_s3_bucket.source.arn}/*"
      ]
    }
  ]
}
EOF
}

data "template_file" "buildspec" {
  template = "${file("${path.module}/buildspec.yml")}"

  vars {
    repository_url     = "${aws_ecr_repository.hackathon.repository_url}"
    region             = "${var.region}"
  }
}


resource "aws_codebuild_project" "hackathon_build" {
  name          = "hackathon-codebuild"
  build_timeout = "10"
  service_role  = "${aws_iam_role.codebuild_role.arn}"

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/docker:17.09.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "${data.template_file.buildspec.rendered}"
  }
}

/* CodePipeline */

resource "aws_codepipeline" "pipeline" {
  name     = "hackthon-pipeline"
  role_arn = "${aws_iam_role.codepipeline_role.arn}"

  artifact_store {
    location = "${aws_s3_bucket.source.bucket}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source"]

      configuration {
        Owner      = "${var.github_organization}"
        Repo       = "${var.github_repository}"
        Branch     = "${var.github_branch}"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source"]
      output_artifacts = ["imagedefinitions"]

      configuration {
        ProjectName = "${aws_codebuild_project.hackathon_build.name}"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["imagedefinitions"]
      version         = "1"

      configuration {
        ClusterName = "${aws_ecs_cluster.hackathon_cluster.name}"
        ServiceName = "${aws_ecs_service.app.name}"
        FileName    = "imagedefinitions.json"
      }
    }
  }
}