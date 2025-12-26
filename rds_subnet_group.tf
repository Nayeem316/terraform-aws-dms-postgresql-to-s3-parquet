resource "aws_db_subnet_group" "rds_hybrid" {
  name        = "rds-hybrid-subnet-group"
  description = "Public subnets for a publicly accessible RDS instance"
  subnet_ids  = aws_subnet.public[*].id

  tags = merge(local.common_tags, { Name = "rds-hybrid-subnet-group" })
}
