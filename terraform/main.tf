provider "aws" {
  region = "sa-east-1"
}

#getting the  latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

#Security Group
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

#EC2 Instance
resource "aws_instance" "nginx_server" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  key_name                    = "nginx-key"
  vpc_security_group_ids      = [aws_security_group.nginx_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker

              systemctl start docker
              systemctl enable docker

              usermod -aG docker ec2-user

              sleep 10

              #process of  creating site1
              mkdir -p /home/ec2-user/site1
              cat <<EOT > /home/ec2-user/site1/index.html
              <h1>Site 1</h1>
              <p>This is my custom nginx site running on EC2</p>
              EOT

              #process of creating site2
              mkdir -p /home/ec2-user/site1/site2
              cat <<EOT > /home/ec2-user/site1/site2/index.html
              <h1>Site 2</h1>
              <p>This is my second nginx site running on EC2</p>
              EOT

              #running nginx
              docker run -d -p 80:80 \
                -v /home/ec2-user/site1:/usr/share/nginx/html \
                --name nginx nginx
              EOF

  tags = {
    Name        = "nginx-multisite-server"
    Project     = "devops-lab"
    Environment = "lab"
    ManagedBy   = "terraform"
  }
}

#Elastic IP
resource "aws_eip" "nginx_eip" {
  domain = "vpc"

  tags = {
    Name = "nginx-eip"
  }
}

#Associate Elastic IP to EC2
resource "aws_eip_association" "nginx_eip_assoc" {
  instance_id   = aws_instance.nginx_server.id
  allocation_id = aws_eip.nginx_eip.id
}
