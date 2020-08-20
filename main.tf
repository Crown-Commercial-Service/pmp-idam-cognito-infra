# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEPLOY A COGNITO USER POOL
# This script deploys a Cognito User Pool with customized settings.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ------------------------------------------------------------------------------
# PROVIDER CONFIGURATION
# ------------------------------------------------------------------------------

# terraform {
#   required_version = ">=0.12"
# }

# provider "aws" {
#   version    = "~> 3.0"
# #   access_key = local.db_creds.aws_access_key
# #   secret_key = local.aws_secret_key
#   region     = var.region
# }

resource "aws_cognito_user_pool" "pmp_user_pool" {
  name = "pmp_user_pool"

  # We allow the public to create user profiles
  # allow_admin_create_user_only = false
  # enable_username_case_sensitivity = false
  # advanced_security_mode           = "ENFORCED"

  username_attributes        = ["email"]
  auto_verified_attributes   = ["email"]
  email_verification_subject = "Crown Commercial Service Verification Code"
  email_verification_message = "<p>Hello,</p><p>Your Crown Commercial Service verification code is: <strong>{####}</strong></p><p>You must use this code within 24 hours of receiving this email.</p><p>Kind regards,<br>Customer Services Team<br>Crown Commercial Service</p>"


  # User self-registration enabled, set to true to prevent self-registration.
  admin_create_user_config {
    allow_admin_create_user_only = false
    invite_message_template {
      email_subject = "Crown Marketplace - Your temporary password"
      email_message = "<p>Welcome to the Crown Marketplace.</p><p>Your username is {username} and temporary password is {####}</p><p><strong>NOTE.</strong>Your username is case-sensitive.</p><p>Access the site at https://cmp.cmpdev.crowncommercial.gov.uk/.</p>"
      sms_message   = "Welcome to the Crown Marketplace. Your username is {username} and temporary password is {####}"
    }
  }

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true

    temporary_password_validity_days = 3
  }


  tags = {
    Owner       = "infra"
    "Name"      = "PMP IDAM servcies"
    Environment = "develop"
    Terraform   = true
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  schema {
    name                = "given_name"
    attribute_data_type = "String"
    mutable             = true
    required            = true

    string_attribute_constraints {
      min_length = 3
      max_length = 256
    }
  }
}

##############################################################
# Create required user pool groups
##############################################################

resource "aws_cognito_user_group" "pmp_user_pool_groups" {
  count        = length(keys(var.pmp_cognito_groups))
  name         = element(keys(var.pmp_cognito_groups), count.index)
  description  = element(values(var.pmp_cognito_groups), count.index)
  user_pool_id = aws_cognito_user_pool.pmp_user_pool.id
}


##############################################################
# create user pool app client
##############################################################
resource "aws_cognito_user_pool_client" "pmp_client" {
  name                                 = "pmp_client"
  user_pool_id                         = aws_cognito_user_pool.pmp_user_pool.id
  refresh_token_validity               = 30
  generate_secret                      = true
  allowed_oauth_flows_user_pool_client = true
  explicit_auth_flows                  = ["ADMIN_NO_SRP_AUTH"]
  callback_urls                        = ["https://www.theapsgroup.com/en-gb/"]
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["email", "openid", "profile", "aws.cognito.signin.user.admin"]
  supported_identity_providers         = ["COGNITO"]

}

##############################################################
# Domain using the current AWS account ID
##############################################################
resource "aws_cognito_user_pool_domain" "ccs_cmp_domain" {
  domain       = data.aws_caller_identity.current.account_id
  user_pool_id = aws_cognito_user_pool.pmp_user_pool.*.id[count.index]
}