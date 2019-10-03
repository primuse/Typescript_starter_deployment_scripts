# paystack-deployment-scripts

## Introduction
This repository contains infrastructure and pipeline configurations to build and deploy a Nodejs, Typescript application with a mongodb data store.
**N/B: To successfully create a codepipeline with a GITHUB source, you have to provide a GITHUB OAuth token**

### Building and Running the application 
- Clone this repo to download the files by running `git clone https://github.com/primuse/Typescript_starter_deployment_scripts.git`
- **Cd** into the **scripts** directory and run `chmod +x deploy.sh` to make the script exceutable.
- Run the script with `./deploy.sh <GITHUB OAuth token>` replacing **GITHUB OAuth token** with your auth token.
- Copy the **alb_hostname** from the terminal and enter it into a broswer to view your application**

### Destroying resources
- Cd to the **root** directory and run `terraform destroy` 



