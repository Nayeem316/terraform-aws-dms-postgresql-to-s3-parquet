resource "aws_security_group" "rds_sg" {
  name        = "rds_hybrid_sg"
  description = "Security group for RDS PostgreSQL"
  vpc_id      = aws_vpc.rds_hybrid_vpc.id

  dynamic "ingress" {
    for_each = var.public_db_allowed_cidr == null ? [] : [var.public_db_allowed_cidr]
    content {
      description = "PostgreSQL access from allowed CIDR"
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "rds_hybrid_sg" })
}

resource "aws_security_group" "dms_sg" {
  name        = "dms_replication_sg"
  description = "Security group for DMS replication instance"
  vpc_id      = aws_vpc.rds_hybrid_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "dms_replication_sg" })
}

resource "aws_security_group_rule" "rds_from_dms" {
  type                     = "ingress"
  security_group_id        = aws_security_group.rds_sg.id
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.dms_sg.id
  description              = "Allow PostgreSQL access from DMS replication instance"
}
