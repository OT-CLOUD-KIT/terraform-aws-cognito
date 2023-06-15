output "module_enabled" {
  description = "Whether the module is enabled"
  value       = var.module_enabled
}
locals {
  user_pool = try(aws_cognito_user_pool.user_pool[0], {})

  o_user_pool_tags = try(local.user_pool.tags, {})

  o_user_pool = var.module_enabled ? merge(local.user_pool, {
    tags = local.o_user_pool_tags != null ? local.user_pool.tags : {}
  }) : null
}
output "user_pool" {
  description = "The full `aws_cognito_user_pool` object."
  value       = local.user_pool.id
}

output "domain" {
  description = "The full `aws_cognito_user_pool` object."
  #value       = aws_cognito_user_pool_domain.domain[0].domain
  value       = try(aws_cognito_user_pool_domain.domain[0], null)

}
output "user_pool_arn" {
  description = "The ARN of the user pool"
  value       = var.module_enabled ? aws_cognito_user_pool.user_pool[0].arn : null
}
