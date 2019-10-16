#!/usr/bin/env bash

set -euo pipefail

function destroyResources {
  cd ../
  terraform destroy -auto-approve
}

function main {
  destroyResources
}

#Calls the main function
main