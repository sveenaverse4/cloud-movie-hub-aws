# AWS Infrastructure for Cloud Movie Hub
provider "aws" {
  region = "us-east-1"
}

# 1. Create the Security Group (The "Gatekeeper")
resource "aws_security_group" "web_traffic" {
  name        = "allow_web"
  description = "Allow port 80 for our pretty website"

  ingress {
    from_port   = 80
    to_port     = 80
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

# 2. Create the EC2 Instance (The "Server")
resource "aws_instance" "pink_server" {
  ami           = "ami-0c101f26f147fa7fd" # Amazon Linux 2023
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_traffic.id]

  # This script runs automatically when the server starts
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl start httpd
              sudo systemctl enable httpd
              EOF

  tags = {
    Name = "Veena-Cloud-Server"
  }
}
