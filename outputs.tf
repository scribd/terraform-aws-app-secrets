output "all" {
  description = "Map of names and arns of created secrets"
  value = [
    for k in keys(var.secrets) : {
      name = upper(replace(k, "-", "_"))
      arn  = aws_secretsmanager_secret.app[k].id
    }
  ]
}
