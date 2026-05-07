# Terraform EC2 Project

This project provisions AWS infrastructure using Terraform for both development and production environments. 
The project creates EC2 instances, security groups, Route53 DNS records, and optionally Elastic IPs.
Apache and PHP are installed automatically using a user data script (`setup.sh`). 
Separate `.tfvars` files are used for each environment to manage configuration values independently. 
Example variable files include `development.tfvars` for the development environment and `production.tfvars` for the production environment. 
To initialize Terraform, run `terraform init`. 
To create an execution plan, use `terraform plan -var-file="development.tfvars"` or `terraform plan -var-file="production.tfvars"` depending on the environment. 
To provision infrastructure, run `terraform apply -var-file="development.tfvars"` or `terraform apply -var-file="production.tfvars"`. 
To destroy resources, use the same commands with `terraform destroy`. 
Ensure that the Route53 hosted zone already exists in AWS before deployment. 
Sensitive files such as `terraform.tfstate`, `terraform.tfstate.backup`, private SSH keys, and `.tfvars` files should not be committed to GitHub and must be added to `.gitignore`.
