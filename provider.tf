terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    #   version = "=3.42.0"
    }
  }
}


provider "aws" {
  region  = var.region
  profile = "CLI_PROFILE_HERE"
}



# provider "aws" {
#   region     = "us-east-1"
#   access_key = "my-access-key"
#   secret_key = "my-secret-key"
# }
