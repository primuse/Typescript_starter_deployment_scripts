#!/usr/bin/env bash

set -euo pipefail

GITHUB_TOKEN=$1

#Builds infrastructure and Launches instances with Terraform
function terraformLaunch {
  cd ../
  terraform init -input=false
  terraform validate
  terraform plan -out=tfplan -input=false
  GITHUB_TOKEN=$GITHUB_TOKEN terraform apply -input=false tfplan
}

function main {
  terraformLaunch
}

#Calls the main function
main