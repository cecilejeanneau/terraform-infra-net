locals {
	normalized_student_name = replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(lower(var.student_name), "à", "a"), "â", "a"), "ä", "a"), "ç", "c"), "é", "e"), "è", "e"), "ê", "e"), "ë", "e"), "î", "i"), "ï", "i")
	name_prefix            = "tf-${local.normalized_student_name}-${var.environment}"
	az                     = "${var.region}a"
	common_tags = {
		course  = "TF-2026-04"
		env     = var.environment
		managed = "terraform"
		owner   = var.student_name
	}
}

data "aws_ami" "ubuntu" {
	most_recent = true
	owners      = ["099720109477"]

	filter {
		name   = "name"
		values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
	}

	filter {
		name   = "virtualization-type"
		values = ["hvm"]
	}
}

resource "aws_vpc" "main" {
	cidr_block           = var.vpc_cidr
	enable_dns_support   = true
	enable_dns_hostnames = true

	tags = merge(local.common_tags, {
		Name = "${local.name_prefix}-vpc"
	})
}

resource "aws_subnet" "public" {
	vpc_id                  = aws_vpc.main.id
	cidr_block              = var.public_subnet_cidr
	availability_zone       = local.az
	map_public_ip_on_launch = true

	tags = merge(local.common_tags, {
		Name = "${local.name_prefix}-subnet-public"
	})
}

resource "aws_subnet" "private" {
	vpc_id            = aws_vpc.main.id
	cidr_block        = var.private_subnet_cidr
	availability_zone = local.az

	tags = merge(local.common_tags, {
		Name = "${local.name_prefix}-subnet-private"
	})
}

resource "aws_internet_gateway" "main" {
	vpc_id = aws_vpc.main.id

	tags = merge(local.common_tags, {
		Name = "${local.name_prefix}-igw"
	})
}

resource "aws_route_table" "public" {
	vpc_id = aws_vpc.main.id

	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.main.id
	}

	tags = merge(local.common_tags, {
		Name = "${local.name_prefix}-rt-public"
	})
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

	tags = merge(local.common_tags, {
		Name = "${local.name_prefix}-sg-web"
	})
}

resource "aws_instance" "web" {
	ami                         = data.aws_ami.ubuntu.id
	instance_type               = "t3.micro"
	subnet_id                   = aws_subnet.public.id
	vpc_security_group_ids      = [aws_security_group.web.id]
	associate_public_ip_address = true
	key_name                    = var.key_pair_name
	user_data                   = file("${path.module}/user-data.sh")

	root_block_device {
		volume_size = 10
		volume_type = "gp3"
		encrypted   = true
	}

	tags = merge(local.common_tags, {
		Name = "${local.name_prefix}-ec2-web"
	})
}
