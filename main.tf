resource "aws_secretsmanager_secret" "app" {
  for_each = var.secrets

  name_prefix = "${var.app_name}-${each.key}"
  description = "The ${title(replace(each.key, "-", " "))} secret for ${var.app_name} application"

  tags = merge(var.tags, { "service" = var.app_name })
}

resource "aws_secretsmanager_secret_version" "app" {
  for_each = var.secrets

  secret_id     = aws_secretsmanager_secret.app[each.key].id
  secret_string = each.value

  lifecycle {
    ignore_changes = [secret_string]
  }
}
