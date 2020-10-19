variable "app_name" {
  description = "Application name"
  type        = string
}

variable "secrets" {
  description = "Key-value map of secrets"
  type        = map(string)
}

variable "tags" {
  description = "Key-value map of tags"
  type        = map(string)

  default = {}
}
