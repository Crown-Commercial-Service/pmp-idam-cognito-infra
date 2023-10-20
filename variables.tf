variable "env_region" {
  default = "eu-west-2"
}

data "aws_caller_identity" "current" {}

variable "env_var" {
  type = string
}

variable "callbackurl" {
  type = string
}

variable "env" {
  type    = map(any)
  default = {}
}

variable "user_pool_name" {
  type        = string
  description = "The name of the Cognito User Pool."
  default     = "pmp_user_pool"
}

variable "pmp_cognito_groups" {
  type = map(any)
  default = {
    "customer"      = "Buyer user access",
    "CustomerAdmin" = "Customer Admin user access",
    "CCS_Owner"     = "CCS Employee user access"
  }
}
