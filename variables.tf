variable "vpc_cidr" {
  description = "The CIDR block of the vpc"
}

variable "public_subnet_cidr" {
  type        = list(string)
  description = "The CIDR block for the public subnet"
}

variable "private_subnet_cidr" {
  type        = list(string)
  description = "The CIDR block for the private subnet"
}

variable "region" {
  description = "The region to create the infrastructure"
}

variable "mongodb_uri" {
  description = "The database connection url"
}

variable "session_secret" {
  description = "The session secret"
}

variable "facebook_id" {
  description = "The facebook ID"
}

variable "facebook_secret" {
  description = "The facebook secret"
}

variable "app_count" {
  description = "The number of application instances to spin up"
}

variable "app_port" {
  description = "The port the application is served on"
}

variable "AWS_ACCESS_KEY_ID" {
  description = "AWS access key ID for authentication"
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS secret key ID for authentication"
}

variable "github_organization" {
  description = "The github user/organization"
}

variable "github_repository" {
  description = "The github repository containing the source files"
}

variable "github_branch" {
  description = "The github branch to build"
}

