locals {
  alias_attributes = var.alias_attributes == null && var.username_attributes == null ? [
    "email",
    "preferred_username",
    "phone_number",
  ] : null
}
resource "aws_cognito_user_pool" "user_pool" {
  count = var.module_enabled ? 1 : 0

  name                     = var.name
  alias_attributes         = var.alias_attributes != null ? var.alias_attributes : local.alias_attributes
  username_attributes      = var.username_attributes
  auto_verified_attributes = var.auto_verified_attributes

  sms_authentication_message = var.sms_authentication_message

  mfa_configuration = var.mfa_configuration

  password_policy {
    minimum_length                   = var.password_minimum_length
    require_lowercase                = var.password_require_lowercase
    require_numbers                  = var.password_require_numbers
    require_symbols                  = var.password_require_symbols
    require_uppercase                = var.password_require_uppercase
    temporary_password_validity_days = var.temporary_password_validity_days
  }

# SMS configuration (need when to use phone number)
   dynamic "sms_configuration" {
    for_each = var.sms_configuration != null ? [var.sms_configuration] : []

    content {
      external_id    = lookup(var.sms_configuration, "external_id", null)
      sns_caller_arn = lookup(var.sms_configuration, "sns_caller_arn", null)
    }
  } 

# AdminCreateUser configuration
  admin_create_user_config {
    allow_admin_create_user_only = var.allow_admin_create_user_only

    invite_message_template {
      email_subject = var.invite_email_subject
      email_message = var.invite_email_message
      sms_message   = var.invite_sms_message
    }
  }

  dynamic "schema" {
    for_each = var.schema_attributes
    iterator = attribute

    content {
      name                     = attribute.value.name
      required                 = try(attribute.value.required, false)
      attribute_data_type      = attribute.value.type
      developer_only_attribute = try(attribute.value.developer_only_attribute, false)
      mutable                  = try(attribute.value.mutable, true)

      dynamic "number_attribute_constraints" {
        for_each = attribute.value.type == "Number" ? [true] : []

        content {
          min_value = lookup(attribute.value, "min_value", null)
          max_value = lookup(attribute.value, "max_value", null)
        }
      }

      dynamic "string_attribute_constraints" {
        for_each = attribute.value.type == "String" ? [true] : []

        content {
          min_length = lookup(attribute.value, "min_length", 0)
          max_length = lookup(attribute.value, "max_length", 2048)
        }
      }
    }
  }
}

locals {
  clients = {
    for client in var.clients : replace(lower(client.name), "/[^a-z0-9]/", "-") => {
      allowed_oauth_flows                  = lookup(client, "allowed_oauth_flows", var.default_client_allowed_oauth_flows)
      allowed_oauth_flows_user_pool_client = lookup(client, "allowed_oauth_flows_user_pool_client", var.default_client_allowed_oauth_flows_user_pool_client)
      allowed_oauth_scopes                 = lookup(client, "allowed_oauth_scopes", var.default_client_allowed_oauth_scopes)
      callback_urls                        = lookup(client, "callback_urls", var.default_client_callback_urls)
      default_redirect_uri                 = lookup(client, "default_redirect_uri", var.default_client_default_redirect_uri)
      explicit_auth_flows                  = lookup(client, "explicit_auth_flows", var.default_client_explicit_auth_flows)
      generate_secret                      = lookup(client, "generate_secret", var.default_client_generate_secret)
      logout_urls                          = lookup(client, "logout_urls", var.default_client_logout_urls)
      read_attributes                      = lookup(client, "read_attributes", var.default_client_read_attributes)
      refresh_token_validity               = lookup(client, "refresh_token_validity", var.default_client_refresh_token_validity)
      supported_identity_providers         = lookup(client, "supported_identity_providers", var.default_client_supported_identity_providers)
      prevent_user_existence_errors        = lookup(client, "prevent_user_existence_errors", var.default_client_prevent_user_existence_errors)
      write_attributes                     = lookup(client, "write_attributes", var.default_client_write_attributes)
      access_token_validity                = lookup(client, "access_token_validity", var.default_client_access_token_validity)
      id_token_validity                    = lookup(client, "id_token_validity", var.default_client_id_token_validity)
      token_validity_units                 = lookup(client, "token_validity_units", var.default_client_token_validity_units)
      enable_token_revocation              = lookup(client, "enable_token_revocation", var.default_client_enable_token_revocation)
    }
  }
}
resource "aws_cognito_user_pool_client" "client" {
  for_each = var.module_enabled ? local.clients : {}

  name = each.key

  allowed_oauth_flows                  = each.value.allowed_oauth_flows
  allowed_oauth_flows_user_pool_client = each.value.allowed_oauth_flows_user_pool_client
  allowed_oauth_scopes                 = each.value.allowed_oauth_scopes
  callback_urls                        = each.value.callback_urls
  default_redirect_uri                 = each.value.default_redirect_uri
  explicit_auth_flows                  = each.value.explicit_auth_flows
  generate_secret                      = each.value.generate_secret
  logout_urls                          = each.value.logout_urls
  read_attributes                      = each.value.read_attributes
  refresh_token_validity               = each.value.refresh_token_validity
  supported_identity_providers         = each.value.supported_identity_providers
  prevent_user_existence_errors        = each.value.prevent_user_existence_errors
  user_pool_id                         = aws_cognito_user_pool.user_pool[0].id
  write_attributes                     = each.value.write_attributes
  access_token_validity                = each.value.access_token_validity
  id_token_validity                    = each.value.id_token_validity

  dynamic "token_validity_units" {
    for_each = each.value.token_validity_units != null ? [each.value.token_validity_units] : []

    content {
      refresh_token = try(token_validity_units.value.refresh_token, null)
      access_token  = try(token_validity_units.value.access_token, null)
      id_token      = try(token_validity_units.value.id_token, null)
    }
  }

  
}
resource "aws_cognito_user_pool_domain" "domain" {
  count = var.module_enabled && var.domain != null ? 1 : 0

  domain          = var.domain
  certificate_arn = var.certificate_arn
  user_pool_id    = aws_cognito_user_pool.user_pool[0].id
}


#===============================================================================
lambda_function
resource "aws_lambda_function" "cognito_lambda" {
  count = length(var.lambda_functions)

  filename      = var.lambda_functions[count.index].filename
  function_name = "${var.env_name}-byoe-${var.lambda_functions[count.index].function_name}"
  role          = var.lambda_functions[count.index].role
  handler       = var.lambda_functions[count.index].handler
  runtime       = var.lambda_functions[count.index].runtime

  environment {
    variables = var.lambda_functions[count.index].environment
  }

  # Nested block to define permission within the lambda function resource
  provisioner "local-exec" {
    command = "sleep 5"
    interpreter = ["bash", "-c"]
  }
}

resource "aws_lambda_permission" "cognito_lambda_permission" {
  for_each      = var.module_enabled ? { for i, func in aws_lambda_function.cognito_lambda : i => func.function_name } : {}
  statement_id  = "AllowExecutionFromCognito"
  action        = "lambda:InvokeFunction"
  function_name = each.value
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = var.module_enabled ? aws_cognito_user_pool.user_pool[0].arn : null 
}



















