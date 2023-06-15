allow_admin_create_user_only = false
#======================================================
#=====================================================
clients = [
  #{ name = "ios" },
  #{ name = "android" },
  { name = "web" },
]

default_client_allowed_oauth_flows    = ["implicit"]
default_client_generate_secret        = false
default_client_explicit_auth_flows    = ["ALLOW_USER_SRP_AUTH" , "ALLOW_REFRESH_TOKEN_AUTH"]
default_client_refresh_token_validity               = 30
default_client_access_token_validity                = 60
default_client_id_token_validity                    = 60
#default_client_token_validity_units                 = null

default_client_enable_token_revocation              = true
default_client_prevent_user_existence_errors        = "ENABLED"
#==================================================================

default_client_callback_urls          = ["https://www.google.com"]
default_client_default_redirect_uri   = "https://www.google.com"
#==================================================================

default_client_supported_identity_providers         = ["COGNITO"]
default_client_logout_urls                          = ["https://www.google.com"]
default_client_allowed_oauth_flows_user_pool_client = true
#=============================================================
default_client_allowed_oauth_scopes   = ["email", "openid"]
default_client_read_attributes        = ["email", "email_verified", "preferred_username"]
default_client_write_attributes       = null



