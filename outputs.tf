output "all" {
  description = "Map of names and arns of created secrets"
  value = [
    for name in keys(local.secrets) : {
      name = upper(replace(name, "-", "_"))
      arn  = aws_secretsmanager_secret.app[name].id
    }
  ]
}

output "kms_key_arn" {
  description = "The master key ARN"
  value       = length(local.arns) > 0 ? aws_kms_key.master[0].arn : null
}

output "kms_alias_arn" {
  description = "The master key alias ARN"
  value       = length(local.arns) > 0 ? aws_kms_alias.master[0].arn : null
}
