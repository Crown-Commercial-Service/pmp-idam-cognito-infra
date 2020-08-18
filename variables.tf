##############################################################
#
# AWS Details
#
# NOTE: Access Key and Secret Key will be pulled from the local
# credentials 
#
# ##############################################################

variable "region" {
  default = "eu-west-2"
}

data "aws_caller_identity" "current" {}

output "aws_account_id" {
  value = "${data.aws_caller_identity.current.account_id}"
}

variable "env" {
  type    = map
  default = {}
}
# data "aws_secretsmanager_secret_version" "creds" {
#   # Fill in the name you gave to your secret
#   secret_id = "aws_cred_dev"
# }

# locals {
#   db_creds = jsondecode(
#     data.aws_secretsmanager_secret_version.creds.secret_string
#   )
# }

# variable "environment_name" {
#   default = "Develop"
# }

# adding groups
variable "pmp_cognito_groups" {
  type = map
  default = {
    "customer"      = "Buyer user access",
    "CustomerAdmin" = "Customer Admin user access",
    "CCS_Owner"     = "CCS Employee user access"
  }
}

# variable "aws_access_key" {
#   type        = string
#   description = "AWS access key"
# }

# variable "aws_secret_key" {
#   type        = string
#   description = "AWS secret key"
# }

# variable "aws_region" {
#   type        = string
#   description = "AWS region"
# }