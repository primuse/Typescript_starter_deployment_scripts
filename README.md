# paystack-deployment-scripts

## Introduction
This repository contains infrastructure and pipeline configurations to build and deploy a Nodejs, Typescript application with a mongodb data store.
**N/B: To successfully create a codepipeline with a GITHUB source, you have to provide a GITHUB OAuth token**

# Table of contents:

- [Pre-reqs](#pre-reqs)
- [Building and Running the application](#building-and-running-the-application)
- [Destroying resources](#destroying-resources)

# Pre-reqs
To build and run this app locally you will need a few things:
- Install [Docker](https://docs.docker.com/install/)

### Building and Running the application 
- Install [Terraform](https://www.terraform.io/)
- Clone this repo to download the files by running 
```
git clone https://github.com/primuse/Typescript_starter_deployment_scripts.git
```
- In the **root** directory, create a `terraform.tfvars` file that contains your `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` and other values for the variables declared in the **varibles.tf** file in the format:

```
AWS_ACCESS_KEY_ID = "**********"
AWS_SECRET_ACCESS_KEY = "************"
```

**N/B** To get your **AWS_ACCESS_KEY_ID** and **AWS_SECRET_ACCESS_KEY**, navigate to your [security credentials dashboard](https://console.aws.amazon.com/iam/home?region=us-east-1#/security_credentials), click on **Access keys** and proceed to **create a new access key**. After creating the access key, download and keep it in a secure place then copy the keys to your **tterraform.tfvars** file.
- After creating the needed variable files for terraform, `cd` into the **scripts** directory by running `cd scripts`
- Run `chmod +x deploy.sh` to make the `deploy.sh` script executable
- Proceed to run the script that automates all the process of building the infrastructure by running `./deploy.sh <GITHUB OAuth token>` replacing **GITHUB OAuth token** with your auth token
- Copy the **alb_hostname** from the terminal and enter it into a browser to view your application

At the end of the script if all goes well, the application can be accessed from the **public facing laodbalancer**


### Destroying resources
- To destroy/cleanup resources, `cd` into the **scripts** directory by running `cd scripts`
- Run `chmod +x cleanup.sh` to make the `cleanup.sh` script executable
- Proceed to run the script that automates destroying all the resources earlier deployed by running `./cleanup.sh`




