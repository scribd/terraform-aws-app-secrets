data "aws_iam_policy_document" "master" {
  count = length(local.arns) > 0 ? 1 : 0

  statement {
    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.account_id]
    }

    actions   = ["kms:*"]
    resources = ["*"]
  }

  statement {
    principals {
      type        = "AWS"
      identifiers = flatten(values(local.arns))
    }

    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
    ]
    resources = ["*"]
  }
}

resource "aws_kms_key" "master" {
  count = length(local.arns) > 0 ? 1 : 0

  description = "The master key for ${var.app_name} application"
  policy      = data.aws_iam_policy_document.master[0].json

  tags = var.tags
}

resource "aws_kms_alias" "master" {
  count = length(local.arns) > 0 ? 1 : 0

  name = "alias/${var.app_name}"

  target_key_id = aws_kms_key.master[0].key_id
}
