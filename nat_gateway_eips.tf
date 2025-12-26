# Elastic IPs for NAT Gateways (no vpc argument)
resource "aws_eip" "nat" {
  count = length(local.azs)

  tags = merge(local.common_tags, { Name = "nat-eip-${count.index + 1}" })
}

# NAT Gateways in public subnets
resource "aws_nat_gateway" "nat" {
  count         = length(local.azs)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(local.common_tags, { Name = "nat-gateway-${count.index + 1}" })
}
