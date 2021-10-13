output "all" {
  description = "Map of names and arns of created secrets"
  value = [
    for name in keys(local.secrets) : {
      name = upper(replace(name, "-", "_"))
      arn  = aws_secretsmanager_secret.app[name].id
    }
  ]
}
