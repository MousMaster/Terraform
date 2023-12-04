variable ebssize {
  type        = number
  description = "set ebs size"
  default     = 2
}

variable "AZ" {
  type    = string
  default = "us-east-1b"
}

variable "maintainer" {
  type    = string
  default = "mous"
}
