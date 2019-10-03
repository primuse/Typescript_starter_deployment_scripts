# Specify the provider and access details
provider "aws" {
  version                 = "~> 2.0"
  access_key              = "${var.AWS_ACCESS_KEY_ID}"
  secret_key              = "${var.AWS_SECRET_ACCESS_KEY}"
  region                  = "${var.region}"
}