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
    amazon-linux-extras install docker -y

    systemctl start docker
    systemctl enable docker

    usermod -aG docker ec2-user

    sleep 10

   
    mkdir -p /home/ec2-user/site1
    echo "<h1>Gabriel de la Cerda Project</h1><p>nginx running on AWS with Terraform + Docker</p>" > /home/ec2-user/site1/index.html

   
    mkdir -p /home/ec2-user/site2
    echo "<h1>Second Site</h1><p>This is another nginx route</p>" > /home/ec2-user/site2/index.html

    
    mkdir -p /home/ec2-user/nginx

    cat <<EOT > /home/ec2-user/nginx/default.conf
    server {
        listen 80;

        location / {
            root /usr/share/nginx/html/site1;
            index index.html;
        }

        location /site2 {
            alias /usr/share/nginx/html/site2;
            index index.html;
        }
    }
    EOT

    docker run -d -p 80:80 \
      -v /home/ec2-user/site1:/usr/share/nginx/html/site1 \
      -v /home/ec2-user/site2:/usr/share/nginx/html/site2 \
      -v /home/ec2-user/nginx/default.conf:/etc/nginx/conf.d/default.conf \
      --name nginx nginx

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
