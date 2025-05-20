variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "enter-your-region"
}

variable "aws_access_key_id" {
  description = "AWS access key ID"
  type        = string
  default     = "enter-your-access-key-id"
}

variable "aws_secret_access_key" {
  description = "AWS secret access key"
  type        = string
  default     = "enter-your-secret-access-key"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "enter-your-instance-type"
}

variable "ami_id" {
  description = "Ubuntu Linux 24.04 AMI ID"
  default     = "enter-your-ami-id"
}

