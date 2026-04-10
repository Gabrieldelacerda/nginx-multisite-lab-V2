This directory contains the Terraform configuration used to provision cloud infrastructure for the Nginx Multisite Lab.

The project was initially developed and tested locally inside a virtual machine, where Nginx serves multiple sites through Docker containers. The environment is prepared and configured using Ansible automation, ensuring consistency across deployments.
Terraform is used to extend the project into the cloud and manage infrastructure in a reproducible way. The configuration in this folder defines a basic AWS environment that hosts the lab. It includes a security group that allows SSH, HTTP, and HTTPS traffic, as well as an EC2 instance that acts as the web server.
The instance runs the same Nginx multisite setup that was previously developed locally. After provisioning, Ansible connects to the instance to install Docker and deploy the containerized environment.

Terraform outputs are defined so that once the infrastructure is created, it becomes easy to retrieve the public IP address of the instance and the SSH command required to connect to it.
The deployment process is fully automated, with Terraform responsible for infrastructure provisioning and Ansible handling server configuration and application deployment.
To run the Terraform configuration, first create a variables file based on the example provided in this directory:

cp terraform.tfvars.example terraform.tfvars

After creating the file, edit it and set the correct values for your environment, such as the AWS key pair name and your public IP address.
Once the variables are configured, initialize Terraform:

terraform init

After initialization, you can preview the changes that Terraform will apply to the infrastructure:

terraform plan

If the plan looks correct, the infrastructure can be created with:

terraform apply
