locals {
  secrets = { for secret in var.secrets : secret.name => secret.value }
  arns    = { for secret in var.secrets : secret.name => secret.allowed_arns if length(secret.allowed_arns) > 0 }
}
