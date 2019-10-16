/*====
Cloudwatch Log Group
======*/
resource "aws_cloudwatch_log_group" "hackathon" {
  name = "hackathon"

  tags = {
    Application = "Hackathon"
  }
}

resource "aws_cloudwatch_log_stream" "hackathon_log_stream" {
  name           = "Hackathon-log-stream"
  log_group_name = aws_cloudwatch_log_group.hackathon.name
}

