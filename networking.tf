module "vpc" {
  azs                          = lookup(var.vpc_config, "azs")
  cidr                         = lookup(var.vpc_config, "cidr_block")
  create_database_subnet_group = true
  database_subnets             = lookup(var.vpc_config, "database_subnets")
  name                         = "${var.name}-vpc"
  tags                         = var.tags
  source                       = "terraform-aws-modules/vpc/aws"
  #version                      = "2.33.0"
}

resource "aws_security_group" "this" {
  description = "Control in/out Traffic RDS Aurora ${var.name}"
  name_prefix = "${var.name}-"
  vpc_id      = module.vpc.vpc_id

  tags = merge(var.tags, {
    Name = var.name
  })
}

resource "aws_security_group_rule" "default_ingress" {
  count                    = length(var.allowed_security_groups)
  description              = "From allowed SGs"
  type                     = "ingress"
  from_port                = aws_rds_cluster.default.port
  to_port                  = aws_rds_cluster.default.port
  protocol                 = "tcp"
  source_security_group_id = element(var.allowed_security_groups, count.index)
  security_group_id        = aws_security_group.this.id
}

resource "aws_security_group_rule" "cidr_ingress" {
  count             = length(var.allowed_cidr_blocks) > 0 ? 1 : 0
  description       = "From allowed CIDRs"
  type              = "ingress"
  from_port         = aws_rds_cluster.default.port
  to_port           = aws_rds_cluster.default.port
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidr_blocks
  security_group_id = aws_security_group.this.id
}