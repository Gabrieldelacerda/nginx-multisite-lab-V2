AWS Environment Setup

As the next step in the evolution of this project, the infrastructure is being prepared to run in the cloud. Until this point, the Nginx multisite environment was running locally inside a virtual machine. The goal moving forward is to deploy the same architecture to a cloud provider and manage the infrastructure programmatically.

To begin this process, an AWS account was created and configured for infrastructure automation. Following best practices, a dedicated IAM user was created instead of using the root account. This user will be used by infrastructure tools to interact with AWS services.

Access keys were generated for this IAM user and stored securely. These credentials allow tools and command line utilities to authenticate with AWS.

The AWS CLI was then installed on the development environment and configured using the generated access credentials. This allows the local machine running the lab environment to interact with AWS programmatically.

To confirm that authentication was successful, the following command was executed:
"aws sts get-caller-identity"

The command returned the AWS account ID and the IAM user information, confirming that the local environment can successfully authenticate with AWS.

With authentication working correctly, the next step in the project will be introducing Terraform. Terraform will be used to provision cloud infrastructure automatically, starting with the creation of a virtual machine instance that will eventually host the Nginx multisite setup.
