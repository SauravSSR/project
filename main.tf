terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

# # Creation of VM in AWS 
#  - Security group 

resource "aws_security_group" "allow_SSH" {
  name        = "allow_SSH"
  description = "Allow SSH inbound traffic"

  #  - INBOUND

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  #  - OUTBOUND RULES

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

#  - key pair

resource "aws_key_pair" "deployer1" {
  key_name   = "deployer-key1"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDuaZXADAdi8pqNMOyErPDCOxX1SAWJED6uI2hqIoFZ5jjABcHqHAXdanVjo1xWX+TqoD7fWO3165dRbGOYkHZof2LBRFid+zyjWirYQ/g1O70Lla2qP9YEgQoLLrip2oXWku5fI9VMjrcBgbpCsh+1vaGUKDMYUUNkI5NCEjSuzdxDCxRbVzRsHu1xUswLD1AtrZR+mDBh1NMx7YzbS5XNiVTBFk0UTA10pFf10D61mPm9HnIFLGOFVhMmwfnClLHLWDkZ0jyXNohYlByPPkleTAQbPXzZSkX6GDYCcsCEsf6mmbmZUMHcqz0OvPjbndwpq4+EVWbIebhK/rJDinBaxjhVScP1+L20QZFLUniB/qOeGiHLNWwa+thCDs832WK0A5GXGUz1sGS1XF7nnewQb7hqVFruRwdys8L0KVuY68RsO/qvwyhlOxRVxW2qd95fF3Ld/FzvnwCFP6/ph+64bGm16kVnaDyg1zUCR2lpGveEsxFIJdsMarUp3xHIWYM= sauravsinghrain@ip-172-31-27-154ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDuaZXADAdi8pqNMOyErPDCOxX1SAWJED6uI2hqIoFZ5jjABcHqHAXdanVjo1xWX+TqoD7fWO3165dRbGOYkHZof2LBRFid+zyjWirYQ/g1O70Lla2qP9YEgQoLLrip2oXWku5fI9VMjrcBgbpCsh+1vaGUKDMYUUNkI5NCEjSuzdxDCxRbVzRsHu1xUswLD1AtrZR+mDBh1NMx7YzbS5XNiVTBFk0UTA10pFf10D61mPm9HnIFLGOFVhMmwfnClLHLWDkZ0jyXNohYlByPPkleTAQbPXzZSkX6GDYCcsCEsf6mmbmZUMHcqz0OvPjbndwpq4+EVWbIebhK/rJDinBaxjhVScP1+L20QZFLUniB/qOeGiHLNWwa+thCDs832WK0A5GXGUz1sGS1XF7nnewQb7hqVFruRwdys8L0KVuY68RsO/qvwyhlOxRVxW2qd95fF3Ld/FzvnwCFP6/ph+64bGm16kVnaDyg1zUCR2lpGveEsxFIJdsMarUp3xHIWYM= sauravsinghrain@ip-172-31-27-154"
}

resource "aws_instance" "amzn-linux" {
  ami                    = "ami-090fa75af13c156b4"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer1.key_name
  vpc_security_group_ids = ["${aws_security_group.allow_SSH.id}"]
  tags = {
    "Name" = "Linux-Node"
    "ENV"  = "Dev"
  }

  depends_on = [aws_key_pair.deployer1]

}