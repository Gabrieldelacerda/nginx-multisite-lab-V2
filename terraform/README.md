This directory contains the Terraform configuration used to provision cloud infrastructure for the Nginx Multisite Lab.
Until this point, the project has been running locally inside a virtual machine where Nginx serves multiple sites through Docker containers. The environment can also be prepared using Ansible automation.
The purpose of introducing Terraform is to extend the project into the cloud and manage infrastructure in a reproducible way.
The configuration in this folder defines a basic AWS environment that will host the lab. It includes a security group that allows SSH, HTTP, and HTTPS traffic, as well as an EC2 instance that will act as the web server.
The instance is intended to run the same Nginx multisite setup that was previously developed locally.
Terraform outputs are defined so that once the infrastructure is created it becomes easy to retrieve the public IP address of the instance and the SSH command required to connect to it.
In the next phase of the project, the instance will be accessed through SSH and prepared to run Docker and the Nginx multisite stack.
The long-term goal is to automate the full deployment pipeline so that the infrastructure is created with Terraform and the server configuration is handled by Ansible.
