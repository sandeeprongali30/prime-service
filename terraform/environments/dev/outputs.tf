output "instance_id" {
  description = "EC2 instance ID"
  value       = module.ec2.instance_id
}

output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = module.ec2.public_ip
}

output "public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = module.ec2.public_dns
}

output "vpn_endpoint" {
  description = "WireGuard VPN endpoint (IP:PORT)"
  value       = "${module.ec2.public_ip}:${module.ec2.vpn_port}"
}