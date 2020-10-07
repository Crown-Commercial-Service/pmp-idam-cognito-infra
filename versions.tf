terraform {
  required_version = ">= 0.12.9"

  required_providers {
    aws = ">= 3.0"
  }


  backend "s3" {}

#   backend "s3" {
#     bucket         = "pmp-terraform-state-${environment}"
#     key            = "ccs-pmp-infra-idam"
#     region         = "eu-west-2"
#     dynamodb_table = "pmp_terraform_state_lock-${environment}"
#     encrypt        = true
#   }
}

  data "terraform_remote_state" "state" {
  backend = "s3"
  config {
   bucket         = "pmp-terraform-state-${var.environment}"
    key            = "ccs-pmp-infra-idam"
    region         = "eu-west-2"
    dynamodb_table = "pmp_terraform_state_lock-${var.environment}"
    encrypt        = true
  }
}
