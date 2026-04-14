output "vpc_id" {
	description = "ID of the VPC"
	value       = module.network.vpc_id
}

output "public_subnet_id" {
	description = "ID of the public subnet"
	value       = module.network.public_subnet_id
}

output "private_subnet_id" {
	description = "ID of the private subnet"
	value       = module.network.private_subnet_id
}

output "web_security_group_id" {
	description = "ID of the web security group"
	value       = module.network.web_security_group_id
}

output "web_instance_public_ip" {
	description = "Public IP of the web instance"
	value       = aws_instance.web.public_ip
}

output "web_instance_public_dns" {
	description = "Public DNS name of the web instance"
	value       = aws_instance.web.public_dns
}

output "web_instance_http_url" {
	description = "HTTP URL of the web instance"
	value       = "http://${aws_instance.web.public_ip}"
}
