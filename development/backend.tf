terraform {
  backend "s3" {
    bucket         = "pmp-terraform-state-develop"
    key            = "ccs-pmp-infra-idam"
    region         = "eu-west-2"
    dynamodb_table = "pmp_terraform_state_lock-develop"
  }
}