output "vpc_id" {
	description = "ID of the VPC"
	value       = aws_vpc.main.id
}

output "public_subnet_id" {
	description = "ID of the public subnet"
	value       = aws_subnet.this["public"].id
}

output "private_subnet_id" {
	description = "ID of the private subnet"
	value       = aws_subnet.this["private"].id
}

output "web_security_group_id" {
	description = "ID of the web security group"
	value       = aws_security_group.web.id
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
