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

variable "delete_in" {
  description = "Number of days to wait before secret deletion"
  type        = number

  default = 30

  validation {
    condition     = var.delete_in == 0 || contains(range(7, 31), var.delete_in)
    error_message = "The delete_in value must be 0 or between 7 and 30."
  }
}

variable "tags" {
  description = "Key-value map of tags"
  type        = map(string)

  default = {}
}
