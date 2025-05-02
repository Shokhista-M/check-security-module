terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "029DA-DevOps24"

    workspaces {
      name = "my_second_workspace"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

}
provider "aws" {
  region = "us-east-1"
}


module "my_vpc" {
    source = "./modules/vpc"
}
resource "aws_subnet" "main" {
    vpc_id = module.my_vpc.vpc_id
    cidr_block = "10.1.0.0/24"
}


module "app_sg" {
    source = "app.terraform.io/029DA-DevOps24/security-030/aws"
    version = "2.0.0"
    security_group = {
        "app_sg" = {
            description = "Security group for the application"
            vpc_id = module.my_vpc.vpc_id
            ingress_rules = [
                {
                    from_port   = 80
                    to_port     = 80
                    description = "HTTP"
                    protocol    = "tcp"
                    cidr_blocks = []
                }
            ]    

        }
    }
}