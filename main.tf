terraform {
  backend "s3" {
    bucket                  = "dc11-dot-hpvlong-networking-terraform-state"
    dynamodb_table          = "dc11-dot-hpvlong-networking-terraform-state-lock"
    key                     = "terraform.tfstate"
    region                  = "ap-southeast-1"
    shared_credentials_file = "~/.aws/credentials"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.16.2"
    }
  }
  required_version = ">= 1.5.7"
}

locals {
  config_file_name      = "${terraform.workspace}.yaml"
  full_config_file_path = "variables/${local.config_file_name}"
  vars                  = yamldecode(file(local.full_config_file_path))
}


provider "aws" {
  region                  = local.vars.region
  profile                 = local.vars.profile
}

