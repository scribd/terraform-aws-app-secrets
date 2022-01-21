data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "access" {
  for_each = local.arns

  statement {
    principals {
      type        = "AWS"
      identifiers = each.value
    }

    actions   = ["secretsmanager:GetSecretValue"]
    resources = ["arn:aws:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:${var.app_name}-${each.key}*"]
  }
}

resource "aws_secretsmanager_secret" "app" {
  for_each = local.secrets

  name_prefix = "${var.app_name}-${each.key}"
  description = "The ${title(replace(each.key, "-", " "))} secret for ${var.app_name} application"

  kms_key_id = length(local.arns) > 0 ? aws_kms_key.master[0].key_id : null

  policy = lookup(local.arns, each.key, null) == null ? null : data.aws_iam_policy_document.access[each.key].json

  tags = merge(var.tags, { "service" = var.app_name })
}

resource "aws_secretsmanager_secret_version" "app" {
  for_each = local.secrets

  secret_id     = aws_secretsmanager_secret.app[each.key].id
  secret_string = each.value != "" ? each.value : "[value required]"

  lifecycle {
    ignore_changes = [secret_string]
  }
}
