##############################################################
#
# AWS Details
#
# NOTE: Access Key and Secret Key will be pulled from the local
# credentials 
#
# ##############################################################

# variable "region" {
#   default = "eu-west-1"
# }

data "aws_caller_identity" "current" {}

output "aws_account_id" {
  # value = "${data.aws_caller_identity.current.account_id}"
}

variable "env_var" {
  type    = string
}

variable "env" {
  type    = map
  default = {}
}

# ------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These variables have defaults, but may be overridden.
# ------------------------------------------------------------------------------

variable "user_pool_name" {
  type        = string
  description = "The name of the Cognito User Pool."
  default     = "pmp_user_pool"
}
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