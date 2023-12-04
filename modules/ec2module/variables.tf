variable instancetype {
  type        = string
  description = "set aws instance type"
  default     = "t2.nano"
}

variable aws_common_tag {
  type        = map
  description = "Set aws tag"
  default = {
    Name = "ec2-eazytraining-bionic"
  }
}

variable "maintainer" {
  type    = string
  default = "ubuntu"
}

variable "ssh_key" {
  type    = string
  default = "devops-mous"
}

variable "public_ip" {
  type    = string
  default = "NULL"
}

variable "AZ" {
  type    = string
  default = "us-east-1b"
}


variable "sg_name" {
  type    = string
  default = "NULL"
}

variable "user" {
  type    = string
  default = "ubuntu"
}