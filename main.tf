terraform {
  backend "s3" {
    bucket                  = "dc11-dot-hpvlong-terraform-state"
    dynamodb_table          = "dc11-dot-hpvlong-terraform-state-lock"
    key                     = "terraform.tfstate"
    region                  = "ap-southeast-1"
    shared_credentials_file = "~/.aws/credentials"
  }
}

provider "aws" {
  region                  = "${terraform.workspace == "test" ? "ap-southeast-1" : "ap-southeast-2"}"
  shared_credentials_files = ["~/.aws/credentials"]
  profile                 = "${terraform.workspace == "test" ? "test" : "stg"}"
}
