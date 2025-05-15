locals {
  env = yamldecode(file("${path.module}/../environments/k8s-env.yaml"))
}

# terraform blocks

terraform {
  required_version = ">= 1.10.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  # backend "s3" {
  #   bucket         = "2025-s4-state"
  #   key            = "k8s-install/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "2025-s4-state-lock"
  # }
}

provider "aws" {
  region = local.env.k8s.aws_region
}

module "k8s-setup" {
  source = "../modules/"
  daryn = local.env.k8s
   tags  = local.env.tags
}