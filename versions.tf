terraform {
  required_version = ">= 0.12.9"

  required_providers {
    aws = ">= 3.0"
  }

  backend "s3" {
    bucket         = "pmp-terraform-state"
    key            = "ccs-pmp-infra-idam"
    region         = "eu-west-2"
    dynamodb_table = "pmp_terraform_state_lock"
    encrypt        = true
  }
}