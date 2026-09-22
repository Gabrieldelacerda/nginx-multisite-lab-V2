# Nginx Multi-Site Lab

This project runs two static websites behind a single Nginx container and routes requests using the HTTP Host header.

The container is built from a versioned Nginx image and loads separate server blocks for `site1.local` and `site2.local`. Each hostname serves content from its own directory.

Run locally with:

docker compose up -d --build

Test the virtual hosts with:

curl -H "Host: site1.local" http://127.0.0.1
curl -H "Host: site2.local" http://127.0.0.1

The repository also contains Terraform and Ansible code used to practice infrastructure provisioning and server configuration in AWS.

The Docker Compose configuration uses the Fluentd logging driver. When the related logging lab is running, Nginx logs can be forwarded to Fluent Bit and stored in Loki. Logging is asynchronous, so the Nginx container can still start when the logging stack is unavailable.

The project covers Nginx virtual hosts, Docker, Terraform, Ansible, AWS and integration with an external logging pipeline.
