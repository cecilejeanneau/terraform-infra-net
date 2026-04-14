module "network" {
  source      = "./modules/network"
  student_name = var.student_name
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr
  subnets      = var.subnets
  common_tags  = local.common_tags
}

moved {
  from = aws_vpc.main
  to   = module.network.aws_vpc.main
}

moved {
  from = aws_subnet.this["public"]
  to   = module.network.aws_subnet.this["public"]
}

moved {
  from = aws_subnet.this["private"]
  to   = module.network.aws_subnet.this["private"]
}

moved {
  from = aws_internet_gateway.main
  to   = module.network.aws_internet_gateway.main
}

moved {
  from = aws_route_table.public
  to   = module.network.aws_route_table.public
}

moved {
  from = aws_route_table_association.public
  to   = module.network.aws_route_table_association.public
}

moved {
  from = aws_security_group.web
  to   = module.network.aws_security_group.web
}
