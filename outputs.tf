output "all" {
  description = "Get a list of created secrets"
  value = [
    for name in keys(local.secrets) : {
      name = upper(replace(name, "-", "_"))
      arn  = aws_secretsmanager_secret.app[name].arn
    }
  ]
}

output "get" {
  description = "Get a map of created secrets"
  value = {
    for name in keys(local.secrets) :
    name => aws_secretsmanager_secret.app[name].arn
  }
}

output "kms_key_arn" {
  description = "The master key ARN"
  value       = length(local.arns) > 0 ? aws_kms_key.master[0].arn : null
}

output "kms_alias_arn" {
  description = "The master key alias ARN"
  value       = length(local.arns) > 0 ? aws_kms_alias.master[0].arn : null
}
