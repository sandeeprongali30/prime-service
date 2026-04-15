terraform {
  required_version = ">= 1.5.0"

    backend "s3" {
    bucket         = "prime-service-terraform-state-01"
    key            = "dev/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-locks"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# AWS Provider
provider "aws" {
  region = var.region
}

# EC2 Module
module "ec2" {
  source = "../../modules/ec2"

  name           = var.name
  ami            = var.ami
  instance_type  = var.instance_type
  user_data_path = var.user_data_path

  vpn_port = var.vpn_port
  tags     = var.tags
}