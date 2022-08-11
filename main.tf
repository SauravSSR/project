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
  name        = "allow_SSH1"
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
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDuHMbZPeFaMWUl8hwwdfjFihMnwu/GawuJdvQ34LJseTT8lKv3HxC5cuCCn/5pIYsjuAjQt/AXGliZjI+qKX0SsTu+ZOQNpi+7ROZGXkeiQGJZfvZteyaG0BylnXvQV7AZiZzE2Nd79mNqFa8Cng3Cztn2qdfjOXxSr5sLDXK0qe8+U7K0umiJ6k/iM3CyKE8IE0dhufDmtk2sDGbZroNircArztwLVK366mj1ECKFcSe/BYdQ2AE/pDqLEcCbJQQDNpkRSTl9sRlG+bjmj4YOZlBkAAu4SLsIcfPTxfHGvqpTwFovHIg0DhxnJpnP4tENOyNbyX33221FGbOgWJu58VhaMM+S4O+Snnw1oqBAToaCv8aCtMFO90NzAP2muLKCsbyLSaQ6ta8ZAix6fwCEmSAeQgbgsjax0fI0m/tYOoflDgaHqqEDlRNDpehVaViV7QrGWfZCmWFjlL9LqLJuzBW1ceRWEbCNmUNXYUz1EPaHNhDrNugB+HitCza72rU= sauravsinghrain@ip-172-31-20-233"
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