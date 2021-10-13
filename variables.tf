variable "app_name" {
  description = "Application name"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string

  default = "us-east-2"
}

variable "secrets" {
  description = "List of objects of secrets"
  type = list(
    object({
      name         = string
      value        = string
      allowed_arns = list(string)
    })
  )
}

variable "tags" {
  description = "Key-value map of tags"
  type        = map(string)

  default = {}
}
