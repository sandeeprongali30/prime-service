variable "name" {
  description = "Name prefix for resources (used for naming and tagging)"
  type        = string
}

variable "ami" {
  description = "AMI ID to use for the EC2 instance (e.g., Ubuntu 22.04)"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type (e.g., t2.micro, t3.medium)"
  type        = string
}

variable "user_data_path" {
  description = "Path to the user_data script used to bootstrap the EC2 instance"
  type        = string
}

variable "vpn_port" {
  description = "UDP port used for WireGuard VPN"
  type        = number
  default     = 51820
}

variable "tags" {
  description = "Tags to apply to AWS resources"
  type        = map(string)

  default = {
    Project = "prime-service"
  }
}