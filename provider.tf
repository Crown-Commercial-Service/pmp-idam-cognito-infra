## =============================================================================
#  Configure the AWS Provider                                                  #
## =============================================================================

# terraform {
#   required_version = ">=0.12"
#   required_providers {
#     aws = "~> 3.0"
#   }
# }

provider "aws" {
  region  = "eu-west-1"
  //profile = var.env["profile"]
}