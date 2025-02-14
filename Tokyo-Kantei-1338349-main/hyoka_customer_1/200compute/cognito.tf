# -----------------------------------------------
# --- Cognito Userpool
# --- Cognito App Client
# -----------------------------------------------

# -----------------------------------------------
# Cognito Userpool
# -----------------------------------------------
resource "aws_cognito_user_pool" "hyoka_userpool" {
  name                = var.cognito_userpool_name
  alias_attributes    = ["email"]
  deletion_protection = "ACTIVE"

  admin_create_user_config {
      allow_admin_create_user_only = true
  }

  password_policy {
      minimum_length                   = 8
      temporary_password_validity_days = 1
      require_numbers                  = true
      require_symbols                  = true
      require_uppercase                = true
      require_lowercase                = true
  }

    schema {
      name                = "name"
      attribute_data_type = "String"
      mutable             = true
      required            = true
      string_attribute_constraints {
        max_length = 2048
        min_length = 0
      }
    }

    schema {
      name                = "family_name"
      attribute_data_type = "String"
      mutable             = true
      required            = true
      string_attribute_constraints {
        max_length = 2048
        min_length = 0
      }
    }

    schema {
      name                = "email"
      attribute_data_type = "String"
      mutable             = true
      required            = true
      string_attribute_constraints {
        max_length = 2048
        min_length = 0
      }
    }

    schema {
        name                = "admin"
        attribute_data_type = "String"
        mutable             = true
        string_attribute_constraints {
            max_length = 30
            min_length = 0
        }
    }
}


# -----------------------------------------------
# Cognito App Client
# -----------------------------------------------
resource "aws_cognito_user_pool_client" "hyoka_client" {
  name                   = "hyoka-client"
  user_pool_id           = aws_cognito_user_pool.hyoka_userpool.id
  explicit_auth_flows    = ["ALLOW_ADMIN_USER_PASSWORD_AUTH","ALLOW_REFRESH_TOKEN_AUTH","ALLOW_USER_PASSWORD_AUTH"]
  refresh_token_validity = 60
  access_token_validity  = 5
  id_token_validity      = 5
  prevent_user_existence_errors = "ENABLED"
  generate_secret        = true

  token_validity_units {
      refresh_token = "minutes"
      access_token  = "minutes"
      id_token      = "minutes"
  }
}