variable "region" {
  description = "AWS region"
  type        = string
}

variable "name" {
  description = "Project name"
  type        = string
}

variable "ami" {
  description = "AMI ID"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "user_data_path" {
  description = "Path to user_data script"
  type        = string
}

variable "vpn_port" {
  description = "WireGuard port"
  type        = number
}

variable "tags" {
  description = "Tags"
  type        = map(string)
}