terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.87.0"
    }
    awscc = {
      source  = "hashicorp/awscc"
      version = "1.23.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

module "main" {
  source = "./module"
}







