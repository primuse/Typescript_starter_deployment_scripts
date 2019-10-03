# outputs.tf

output "alb_hostname" {
  value = "${aws_alb.alb_hackathon.dns_name}"
}