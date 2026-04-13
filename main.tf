locals {
	name_prefix = "tf-${var.student_name}-${var.environment}"
	az          = "${var.region}a"
}

resource "aws_vpc" "main" {
	cidr_block           = var.vpc_cidr
	enable_dns_support   = true
	enable_dns_hostnames = true

	tags = {
		Name = "${local.name_prefix}-vpc"
	}
}

resource "aws_subnet" "public" {
	vpc_id                  = aws_vpc.main.id
	cidr_block              = var.public_subnet_cidr
	availability_zone       = local.az
	map_public_ip_on_launch = true

	tags = {
		Name = "${local.name_prefix}-subnet-public"
	}
}

resource "aws_subnet" "private" {
	vpc_id            = aws_vpc.main.id
	cidr_block        = var.private_subnet_cidr
	availability_zone = local.az

	tags = {
		Name = "${local.name_prefix}-subnet-private"
	}
}

resource "aws_internet_gateway" "main" {
	vpc_id = aws_vpc.main.id

	tags = {
		Name = "${local.name_prefix}-igw"
	}
}

resource "aws_route_table" "public" {
	vpc_id = aws_vpc.main.id

	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.main.id
	}

	tags = {
		Name = "${local.name_prefix}-rt-public"
	}
}

resource "aws_route_table_association" "public" {
	subnet_id      = aws_subnet.public.id
	route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "web" {
	name        = "${local.name_prefix}-sg-web"
	description = "Allow SSH and HTTP from anywhere"
	vpc_id      = aws_vpc.main.id

	ingress {
		description = "SSH"
		from_port   = 22
		to_port     = 22
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		description = "HTTP"
		from_port   = 80
		to_port     = 80
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}

	tags = {
		Name = "${local.name_prefix}-sg-web"
	}
}
