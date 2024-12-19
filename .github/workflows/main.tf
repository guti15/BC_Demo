provider "aws" {
  region     = var.region
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

resource "aws_instance" "bc_demo" {
  ami           = data.aws_ami.amazon_linux_2023_latest.id
  instance_type = "t4g.micro"

  tags = {
    test = "True"
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y git
              EOF

  key_name = var.key_name
}

data "aws_ami" "amazon_linux_2023_latest" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-al2023-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

variable "region" {
  description = "The AWS region to deploy the instance in."
  type        = string
}

variable "aws_access_key_id" {
  description = "Your AWS access key ID."
  type        = string
}

variable "aws_secret_access_key" {
  description = "Your AWS secret access key."
  type        = string
}

variable "key_name" {
  description = "The name of the EC2 Key Pair to use for SSH access."
  type        = string
}