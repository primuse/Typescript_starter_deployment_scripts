# paystack-deployment-scripts

## Introduction
This repository contains infrastructure and pipeline configurations to build and deploy a Nodejs, Typescript application with a mongodb data store.
**N/B: To successfully create a codepipeline with a GITHUB source, you have to provide a GITHUB OAuth token**

### Building and Running the application 
- Install **terraform**
- Clone this repo to download the files by running `git clone https://github.com/primuse/Typescript_starter_deployment_scripts.git`
- In the **root** directory, create a `terraform.tfvars` file that contains your `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` and other values for the variables declared in the **varibles.tf** file in the format:

```
AWS_ACCESS_KEY_ID = "**********"
AWS_SECRET_ACCESS_KEY = "************"
```

- After creating the needed variable files for terraform, `cd` into the **scripts** directory by running `cd scripts`
- Run `chmod +x deploy.sh` to make the `deploy.sh` script executable
- Proceed to run the script that automates all the process of building the infrastructure by running `./deploy.sh <GITHUB OAuth token>` replacing **GITHUB OAuth token** with your auth token
- Copy the **alb_hostname** from the terminal and enter it into a broswer to view your application**

At the end of the script if all goes well, the application can be accessed from the **public facing laodbalancer**


### Destroying resources
- Cd to the **root** directory and run `terraform destroy` 



