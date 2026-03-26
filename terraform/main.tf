provider "aws" {
  region = "sa-east-1"
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_security_group" "nginx_sg" {
  name = "nginx-multisite-sg-v2"

  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "nginx_server" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  key_name      = "nginx-key"

  vpc_security_group_ids = [aws_security_group.nginx_sg.id]

  user_data = <<-EOF
#!/bin/bash
yum update -y
EOF

  tags = {
    Name = "nginx-multisite-server"
  }
}

resource "aws_eip" "nginx_eip" {
  instance = aws_instance.nginx_server.id
}

output "instance_ip" {
  value = aws_eip.nginx_eip.public_ip
}

output "ssh" {
  value = "ssh -i nginx-key.pem ec2-user@${aws_eip.nginx_eip.public_ip}"
}
