output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.nginx_server.public_ip
}

output "ssh_command" {
  description = "SSH command to connect"
  value       = "ssh -i nginx-key.pem ec2-user@${aws_instance.nginx_server.public_ip}"
}
