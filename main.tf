resource "aws_cognito_user_pool" "user_pool" {
  name = var.user_pool_name

  username_attributes        = ["email"]
  auto_verified_attributes   = ["email"]
  email_verification_subject = "Print Marketplace verification code"
  email_verification_message = "<p>Hello,</p><p>Your Crown Commercial Service verification code is: <strong>{####}</strong></p><p>You must use this code within 24 hours of receiving this email.</p><p>Kind regards,<br>Customer Services Team<br>Crown Commercial Service</p>"

  admin_create_user_config {
    allow_admin_create_user_only = false
    invite_message_template {
      email_subject = "Print Marketplace - Your temporary password"
      email_message = "<p>Welcome to the Print Marketplace.</p><p>Your username is {username} and temporary password is {####}</p><p><strong>NOTE.</strong>Your username is case-sensitive.</p><p>Access the site at add-website-url.</p>"
      sms_message   = "Welcome to the Print Marketplace. Your username is {username} and temporary password is {####}"
    }
  }
  password_policy {
    minimum_length    = 10
    require_lowercase = true
    require_numbers   = true
    require_symbols   = false
    require_uppercase = true

    temporary_password_validity_days = 7
  }


  tags = {
    Owner     = "infra"
    Name      = "PMP IDAM servcies"
    Terraform = true
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
    name                = "name"
    attribute_data_type = "String"
    mutable             = true
    required            = true

    string_attribute_constraints {
      min_length = 2
      max_length = 256
    }
  }

  schema {
    name                = "family_name"
    attribute_data_type = "String"
    mutable             = true
    required            = true

    string_attribute_constraints {
      min_length = 2
      max_length = 256
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "organisation_name"
    required                 = false

    string_attribute_constraints {
      min_length = 3
      max_length = 256
    }
  }
}

resource "aws_cognito_user_group" "pmp_user_pool_groups" {
  count        = length(keys(var.pmp_cognito_groups))
  name         = element(keys(var.pmp_cognito_groups), count.index)
  description  = element(values(var.pmp_cognito_groups), count.index)
  user_pool_id = aws_cognito_user_pool.user_pool.id
}

resource "aws_cognito_user_pool_client" "pmp_client" {
  name                                 = "pmp_client-${var.env_var}"
  user_pool_id                         = aws_cognito_user_pool.user_pool.id
  refresh_token_validity               = 5
  generate_secret                      = true
  allowed_oauth_flows_user_pool_client = true
  explicit_auth_flows                  = ["ADMIN_NO_SRP_AUTH", "USER_PASSWORD_AUTH"]
  callback_urls                        = var.cognito_callback_urls_pmp_client
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["phone", "email", "openid", "profile", "aws.cognito.signin.user.admin"]
  supported_identity_providers         = ["COGNITO"]

  # Ignore lifecycle changes
  lifecycle {
    ignore_changes = [
      generate_secret,
    ]
  }
}

resource "aws_cognito_user_pool_client" "pmp_client_ccs" {
  name                                 = "pmp_client_ccs-${var.env_var}"
  user_pool_id                         = aws_cognito_user_pool.user_pool.id
  refresh_token_validity               = 5
  generate_secret                      = true
  allowed_oauth_flows_user_pool_client = true
  explicit_auth_flows                  = ["ADMIN_NO_SRP_AUTH", "USER_PASSWORD_AUTH"]
  callback_urls                        = var.cognito_callback_urls_pmp_client_ccs
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["phone", "email", "openid", "profile", "aws.cognito.signin.user.admin"]
  supported_identity_providers         = ["COGNITO"]

  # Ignore lifecycle changes
  lifecycle {
    ignore_changes = [
      generate_secret,
    ]
  }
}
