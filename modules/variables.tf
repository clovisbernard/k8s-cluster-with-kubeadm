variable "daryn" {
  type = object({
    aws_region      = string
    instance_type   = string
    key_name        = string
  })
  description = " "
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to apply to resources"
}