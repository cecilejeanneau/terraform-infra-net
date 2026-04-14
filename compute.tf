data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = [var.ami_owner]

  filter {
    name   = "name"
    values = [var.ami_name_pattern]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  subnet_id                   = module.network.public_subnet_id
  vpc_security_group_ids      = [module.network.web_security_group_id]
  associate_public_ip_address = true
  key_name                    = coalesce(var.key_name, var.key_pair_name)
  user_data                   = file("${path.module}/user-data.sh")

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
    encrypted   = true
    tags = local.root_volume_tags
  }

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-ec2-web"
  })
}

resource "aws_security_group" "imported" {
  name        = "tf-cecile-dev-sg-import"
  description = "SG importe depuis la console"
  vpc_id      = module.network.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
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
    Name = "${local.prefix}-sg-import"
  })
}

import {
  to = aws_security_group.imported
  id = "sg-029d19753fce29245"
}
