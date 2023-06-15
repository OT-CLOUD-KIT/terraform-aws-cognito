variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "name" {
  type        = string
  description = "(Required) The name of the user pool."
  default = "muvin-pool"
}

variable "alias_attributes" {
  type        = set(string)
  description = "(Optional) Attributes supported as an alias for this user pool. Possible values: 'phone_number', 'email', or 'preferred_username'. Conflicts with username_attributes."
  default     = ["email"]
}

variable "username_attributes" {
  type        = set(string)
  description = "(Optional) Specifies whether email addresses or phone numbers can be specified as usernames when a user signs up. Conflicts with alias_attributes."
  default     = null
}
variable "module_enabled" {
  type        = bool
  description = "(Optional) Whether to create resources within the module or not."
  default     = true
}
variable "auto_verified_attributes" {
  type        = set(string)
  description = "(Optional) The attributes to be auto-verified. Possible values: 'email', 'phone_number'."
  default = [
    "email"
  ]
}
#===================================================================
# SMS configuration
variable "sms_configuration" {
  description = "(Optional) The `sms_configuration` with the `external_id` parameter used in iam role trust relationships and the `sns_caller_arn` parameter to set he arn of the amazon sns caller. this is usually the iam role that you've given cognito permission to assume."
  type = object({
    # The external ID used in IAM role trust relationships. For more information about using external IDs, see https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_create_for-user_externalid.html
    external_id = string
    # The ARN of the Amazon SNS caller. This is usually the IAM role that you've given Cognito permission to assume.
    sns_caller_arn = string
  })
  default = null
}
#===========================================================================
#variable "allow_admin_create_user_only" {
#  type        = bool
#  description = "(Optional) Set to True if only the administrator is allowed to create user profiles. Set to False if users can sign themselves up via an app."
#  default     = true
#}
variable "sms_authentication_message" {
  type        = string
  description = "(Optional) A string representing the SMS authentication message. The message must contain the {####} placeholder, which will be replaced with the authentication code."
  default     = "Your temporary password is {####}."
}

variable "mfa_configuration" {
  type        = string
  description = "Multi-Factor Authentication (MFA) configuration for the User Pool. Valid values: 'ON', 'OFF' or 'OPTIONAL'. 'ON' and 'OPTIONAL' require at least one of 'sms_configuration' or 'software_token_mfa_configuration' to be configured."
  default     = "OFF"
}
variable "password_minimum_length" {
  type        = number
  description = "(Optional) The minimum length of the password policy that you have set."
  default     = 8
}

variable "password_require_lowercase" {
  type        = bool
  description = "(Optional) Whether you have required users to use at least one lowercase letter in their password."
  default     = true
}

variable "password_require_numbers" {
  type        = bool
  description = "(Optional) Whether you have required users to use at least one number in their password."
  default     = true
}
variable "password_require_symbols" {
  type        = bool
  description = "(Optional) Whether you have required users to use at least one symbol in their password."
  default     = true
}

variable "password_require_uppercase" {
  type        = bool
  description = "(Optional) Whether you have required users to use at least one uppercase letter in their password."
  default     = true
}

variable "temporary_password_validity_days" {
  type        = number
  description = "(Optional) In the password policy you have set, refers to the number of days a temporary password is valid. If the user does not sign-in during this time, their password will need to be reset by an administrator."
  default     = 1
}
variable "allow_admin_create_user_only" {
  type        = bool
  description = "(Optional) Set to True if only the administrator is allowed to create user profiles. Set to False if users can sign themselves up via an app."
  default     = false
}
variable "invite_email_subject" {
  type        = string
  description = "(Optional) The subject for email messages."
  default     = "Your new account."
}

variable "invite_email_message" {
  type        = string
  description = "(Optional) The message template for email messages. Must contain {username} and {####} placeholders, for username and temporary password, respectively."
  default     = "Your username is {username} and your temporary password is '{####}'."
}

variable "invite_sms_message" {
  type        = string
  description = "(Optional) The message template for SMS messages. Must contain {username} and {####} placeholders, for username and temporary password, respectively."
  default     = "Your username is {username} and your temporary password is '{####}'."
}
variable "schema_attributes" {
  description = "(Optional) A list of schema attributes of a user pool. You can add a maximum of 25 custom attributes."
  type        = any
  default = []
}
variable "domain" {
  description = "(Optional) Type a domain prefix to use for the sign-up and sign-in pages that are hosted by Amazon Cognito, e.g. 'https://{YOUR_PREFIX}.auth.eu-west-1.amazoncognito.com'. The prefix must be unique across the selected AWS Region. Domain names can only contain lower-case letters, numbers, and hyphens."
  type        = string
  default     = "mymobile"
}

variable "certificate_arn" {
  description = "(Optional) The ARN of an ISSUED ACM certificate in us-east-1 for a custom domain."
  type        = string
  default     = null
}
variable "clients" {
  description = "(Optional) A list of objects with the clients definitions."
  type        = any
}
variable "default_client_allowed_oauth_flows" {
  description = "(Optional) List of allowed OAuth flows. Possible flows are 'code', 'implicit', and 'client_credentials'."
  type        = list(string)
  default     = ["implicit"]
}

variable "default_client_allowed_oauth_flows_user_pool_client" {
  description = "(Optional) Whether the client is allowed to follow the OAuth protocol when interacting with Cognito User Pools."
  type        = bool
  default     = true
}

variable "default_client_allowed_oauth_scopes" {
  description = "(Optional) List of allowed OAuth scopes. Possible values are 'phone', 'email', 'openid', 'profile', and 'aws.cognito.signin.user.admin'."
  type        = list(string)
  default     = ["email", "openid"]
}
variable "default_client_callback_urls" {
  description = "(Optional) List of allowed callback URLs for the identity providers."
  type        = list(string)
  default     = ["www.google.com"]
}

variable "default_client_default_redirect_uri" {
  description = "(Optional) The default redirect URI. Must be in the list of callback URLs."
  type        = string
  default     = "www.google.com"
}

variable "default_client_explicit_auth_flows" {
  description = "(Optional) List of authentication flows. Possible values are 'ADMIN_NO_SRP_AUTH', 'CUSTOM_AUTH_FLOW_ONLY', 'USER_PASSWORD_AUTH', 'ALLOW_ADMIN_USER_PASSWORD_AUTH', 'ALLOW_CUSTOM_AUTH', 'ALLOW_USER_PASSWORD_AUTH', 'ALLOW_USER_SRP_AUTH', and 'ALLOW_REFRESH_TOKEN_AUTH'."
  type        = list(string)
  default     = ["ALLOW_USER_SRP_AUTH" , "ALLOW_REFRESH_TOKEN_AUTH"]
}

variable "default_client_generate_secret" {
  description = "(Optional) Boolean flag for generating an application secret."
  type        = bool
  default     = false
}

variable "default_client_logout_urls" {
  description = "(Optional) List of allowed logout URLs for the identity providers."
  type        = list(string)
  default     = ["www.google.com"]
}
variable "default_client_read_attributes" {
  description = "(Optional) List of Cognito User Pool attributes the application client can read from."
  type        = list(string)
  default     = ["email", "email_verified", "preferred_username"]
}

variable "default_client_refresh_token_validity" {
  description = "(Optional) The time limit in days refresh tokens are valid for."
  type        = number
  default     = 30
}

variable "default_client_prevent_user_existence_errors" {
  description = "(Optional) Choose which errors and responses are returned by Cognito APIs during authentication, account confirmation, and password recovery when the user does not exist in the Cognito User Pool. When set to 'ENABLED' and the user does not exist, authentication returns an error indicating either the username or password was incorrect, and account confirmation and password recovery return a response indicating a code was sent to a simulated destination. When set to 'LEGACY', those APIs will return a 'UserNotFoundException' exception if the user does not exist in the Cognito User Pool."
  type        = string
  default     = "ENABLED"
}

variable "default_client_supported_identity_providers" {
  description = "(Optional) List of provider names for the identity providers that are supported on this client."
  type        = list(string)
  default     = ["COGNITO"]
}

variable "default_client_write_attributes" {
  description = "(Optional) List of Cognito User Pool attributes the application client can write to."
  type        = list(string)
  default     = null
}

variable "default_client_access_token_validity" {
  description = "(Optional) Time limit, between 5 minutes and 1 day, after which the access token is no longer valid and cannot be used. This value will be overridden if you have entered a value in 'default_client_token_validity_units'."
  type        = number
  default     = 60
}

variable "default_client_id_token_validity" {
  description = "(Optional) Time limit, between 5 minutes and 1 day, after which the ID token is no longer valid and cannot be used. This value will be overridden if you have entered a value in 'default_client_token_validity_units'."
  type        = number
  default     = 60
}
variable "default_client_token_validity_units" {
  description = "(Optional) Configuration block for units in which the validity times are represented in."
  type = object({
    refresh_token = optional(string)
    access_token  = optional(string)
    id_token      = optional(string)
  })
  default = {
    refresh_token = "days"
    access_token  = "minutes"
    id_token      = "minutes"
  }
}
                    
variable "default_client_enable_token_revocation" {
  description = "(Optional) Enables or disables token revocation."
  type        = bool
  default     = true
}
variable "lambda_create_auth_challenge" {
  type        = string
  description = "(Optional) The ARN of an AWS Lambda creating an authentication challenge."
  default     = null
}

variable "lambda_custom_message" {
  type        = string
  description = "(Optional) The ARN of a custom message AWS Lambda trigger."
  default     = null
}

variable "lambda_define_auth_challenge" {
  type        = string
  description = "(Optional) The ARN of an AWS Lambda that defines the authentication challenge."
  default     = null
}

variable "lambda_post_authentication" {
  type        = string
  description = "(Optional) The ARN of a post-authentication AWS Lambda trigger."
  default     = null
}
variable "lambda_post_confirmation" {
  type        = string
  description = "(Optional) The ARN of a post-confirmation AWS Lambda trigger."
  default     = null
}

variable "lambda_pre_authentication" {
  type        = string
  description = "(Optional) The ARN of a pre-authentication AWS Lambda trigger."
  default     = null
}

variable "lambda_pre_sign_up" {
  type        = string
  description = "(Optional) The ARN of a pre-registration AWS Lambda trigger."
  default     = null
}

variable "lambda_pre_token_generation" {
  type        = string
  description = "(Optional) The ARN of an AWS Lambda that allows customization of identity token claims before token generation."
  default     = null
}
variable "lambda_user_migration" {
  type        = string
  description = "(Optional) The ARN of the user migration AWS Lambda config type."
  default     = null
}

variable "lambda_verify_auth_challenge_response" {
  type        = string
  description = "(Optional) The ARN of an AWS Lambda that verifies the authentication challenge response."
  default     = null
}
#==================================================================
#lambda_functions_variable
variable "env_name" {
  type    = string
  default = "my-environment"
}

variable "lambda_functions" {
  type = list(object({
    filename      = string
    function_name = string
    role          = string
    handler       = string
    runtime       = string
    environment   = map(string)
  }))
  default = [
    {
      filename      = ""
      function_name = ""
      role          = ""
      handler       = ""
      runtime       = ""
      environment   = {}  # Empty environment for the first element

    },
    {
      filename      = ""
      function_name = ""
      role          = ""
      handler       = ""
      runtime       = ""
      environment = {
        BYOE_USER_SERVICES_BASE_PATH = ""
      }
    },
    {
      filename      = ""
      function_name = ""
      role          = ""
      handler       = ""
      runtime       = ""
      environment   = {}  # Empty environment for the first element
    }
  ]
}








