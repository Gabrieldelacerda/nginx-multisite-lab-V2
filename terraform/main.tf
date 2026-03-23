provider "aws" {
  region = "sa-east-1"
}

# Get latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Security Group
resource "aws_security_group" "nginx_sg" {
  name        = "nginx-multisite-sg"
  description = "Allow SSH, HTTP, HTTPS"

  ingress {
    description = "SSH (your IP)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["200.169.13.2/32"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "nginx-multisite-sg"
    Project     = "devops-lab"
    Environment = "lab"
    ManagedBy   = "terraform"
  }
}

# EC2 Instance
resource "aws_instance" "nginx_server" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  key_name                    = "nginx-key"
  vpc_security_group_ids      = [aws_security_group.nginx_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install docker -y

              systemctl start docker
              systemctl enable docker

              usermod -aG docker ec2-user

              sleep 10

              # site1
              mkdir -p /home/ec2-user/site1
              cat <<EOT > /home/ec2-user/site1/index.html
              <h1>Site 1</h1>
              <p>This is site 1</p>
              EOT

              # site2
              mkdir -p /home/ec2-user/site2
              cat <<EOT > /home/ec2-user/site2/index.html
              <h1>Site 2</h1>
              <p>This is site 2</p>
              EOT

              # custom nginx config
              mkdir -p /home/ec2-user/nginx
              cat <<EOT > /home/ec2-user/nginx/default.conf
              server {
                  listen 80;

                  location / {
                      root /usr/share/nginx/html/site1;
                      index index.html;
                  }

                  location /site2 {
                      root /usr/share/nginx/html;
                      index index.html;
                  }
              }
              EOT

              # run nginx with both sites
              docker run -d -p 80:80 \
                -v /home/ec2-user/site1:/usr/share/nginx/html/site1 \
                -v /home/ec2-user/site2:/usr/share/nginx/html/site2 \
                -v /home/ec2-user/nginx/default.conf:/etc/nginx/conf.d/default.conf \
                --name nginx nginx
              EOF

  tags = {
    Name        = "nginx-multisite-server"
    Project     = "devops-lab"
    Environment = "lab"
    ManagedBy   = "terraform"
  }
}
