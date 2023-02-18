# Deploying Apache web server using Terraform and Ansible

This repository contains code for deploying an Apache web server on an AWS EC2 instance using Terraform and Ansible. This document provides instructions for setting up and deploying the infrastructure and application.

## Prerequisites
Before getting started, make sure you have the following tools installed:

- Terraform
- Ansible
- AWS CLI

Additionally, make sure that you have an AWS account set up and have access and secret keys with the necessary permissions.

## Getting started
1. Clone the repository to your local machine.
2. Navigate to the terraform directory and create a variable.tf file containing the following variable:
      
         
     
        variable "aws_region" {
        default     = "<"AWS-REGION">"
        description = "Sets aws region"
        }
     
    
3. Initialize the Terraform working directory by running the following command:
   
   
   
         terraform init
         
4. Review the main.tf file to make sure it is configured correctly for your needs.
5. Create the infrastructure by running the following command:
   
   
   
   
         terraform apply

6. Once the infrastructure is created, navigate to the ansible directory and create an ansible.cfg file with the following contents:
  
  
  
  
         [defaults]
         inventory = <name of host inventory file>
         remote_user = < hostname>
         private_key_file = <path to EC2 private key>
         
 7. Update the `hosts` file to include the IP address of the EC2 instance created in step 5.
 8. Run the Ansible playbook to deploy the Apache web server by running the following command:
 
 
 
         
         ansible-playbook <playbook name>.yml


## Accessing the application
Once the deployment is complete, you should be able to access the Apache web server by entering the IP address of the EC2 instance into a web browser.




