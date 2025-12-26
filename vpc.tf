resource "aws_vpc" "rds_hybrid_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge({ Name = "rds_hybrid_vpc" }, local.common_tags)
}

# Internet Gateway for public subnets
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.rds_hybrid_vpc.id
  tags   = merge(local.common_tags, { Name = "rds_hybrid_igw" })
}
