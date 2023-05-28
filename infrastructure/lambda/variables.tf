variable "source_dir" {
  type = string
}

variable "name" {
  type = string
}

variable "runtime" {
  type = string
}

variable "variables" {}

variable "custom_policy_json" {
  type = string
  default = <<-EOT
  {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Sid": "noop",
              "Effect": "Allow",
              "Action": "none:null",
              "Resource": "*"
          }
      ]
  }
  EOT
}

variable "handler" {
  type = string
}
