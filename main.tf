terraform {
  backend "s3" {
    bucket                  = "dc11-dot-hpvlong-terraform-state"
    key                     = "my-terraform-project"
    region                  = "ap-southeast-1"
    shared_credentials_file = "~/.aws/credentials"
  }
}

provider "aws" {
  region                  = "ap-southeast-1"
  shared_credentials_files = ["~/.aws/credentials"]
  profile                 = "default"
}


resource "aws_s3_bucket" "New_bucket" {
  bucket = "dc11-dot-hpvlong-terraform-state2"
  acl    = "private"

  tags = {
    Name = "hpvlong"
  }
}