EC2 Docker Setup!

==Overview==
Docker was installed and configured on the EC2 instance provisioned via Terraform to prepare the environment for containerized workloads.

==Implementation==
The instance was accessed over SSH using the project key pair. The base system was already up to date, so no package upgrades were required at the time of execution. Docker was installed using the Amazon Linux extras repository, which provides the officially supported distribution for Amazon Linux 2.
After installation, the Docker daemon was started and enabled to persist across reboots. User-level access was configured by adding "ec2-user" to the Docker group, allowing container management without requiring root privileges. A new session was established to apply the updated group membership.

==Verification==
Docker availability and permissions were validated by running "docker ps", confirming that the daemon was active and accessible without "sudo".

==Context==
This step was executed manually as part of the initial environment setup. Future iterations should incorporate this configuration into instance provisioning (via Terraform `user_data`) to ensure consistency and eliminate manual intervention.
