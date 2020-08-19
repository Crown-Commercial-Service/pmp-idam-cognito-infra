## =============================================================================
#  Configure the AWS Provider                                                  #
## =============================================================================

terraform {
  required_version = ">=0.12"
  required_providers {
    aws = "~> 3.0"
  }
}

provider "aws" {
  region  = var.region
  //profile = var.env["profile"]
}