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
  subnet_id                   = aws_subnet.this["public"].id
  vpc_security_group_ids      = [aws_security_group.web.id]
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
