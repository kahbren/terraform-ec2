provider "aws" {
  region = "us-east-1" # Replace with your desired AWS region
}

# Terraform S3 Backend for State Management
terraform {
  backend "s3" {
    bucket         = "devops-iac-terraform-state-bucket" # Replace with your S3 bucket name
    key            = "ec2/terraform.tfstate"       # State file path in the bucket
    region         = "us-east-1"                  # S3 bucket region
  }
}

# Security Group for allowing SSH
resource "aws_security_group" "terraform_ec2" {
  name        = "terraform_ec2_sg"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Use carefully, restrict access in production
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance 1
resource "aws_instance" "instance_1" {
  ami           = "ami-0e2c8caa4b6378d8c" # Replace with a valid AMI ID
  instance_type = "t3.micro"
  key_name      = "terraform_ec2_kpa" # Replace with your SSH key pair name
  security_groups = [
    aws_security_group.terraform_ec2.name
  ]

  tags = {
    Name = "Instance1"
  }
}

# EC2 Instance 2
resource "aws_instance" "instance_2" {
  ami           = "ami-0e2c8caa4b6378d8c"
  instance_type = "t3.micro"
  key_name      = "terraform_ec2_kpa"
  security_groups = [
    aws_security_group.terraform_ec2.name
  ]

  tags = {
    Name = "Instance2"
  }
}

