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
  profile = "nana"
}



# provider "aws" {
#   region     = "us-west-2"
#   access_key = "my-access-key"
#   secret_key = "my-secret-key"
# }