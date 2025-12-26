resource "aws_db_subnet_group" "rds_hybrid" {
  name        = "rds-hybrid-subnet-group"
  description = "Private subnets for RDS"
  subnet_ids  = aws_subnet.private[*].id

  tags = merge(local.common_tags, { Name = "rds-hybrid-subnet-group" })
}
