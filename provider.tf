terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

variable "ssh_allowed_cidr" {
  description = "Public IPv4 CIDR allowed to SSH into EC2"
  type        = string
}