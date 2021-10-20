resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    {
      Name = "${var.project_name}-IGW"
    },
    local.standard_tags
  )
}

resource "aws_eip" "nat" {
  vpc = true
  tags = merge(
    {
      Name = "${var.project_name}-NAT-EIP"
    },
    local.standard_tags
  )
}

resource "aws_nat_gateway" "gw" {
  depends_on    = [aws_eip.nat]
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    {
      Name = "${var.project_name}-NAT-GW"
    },
    local.standard_tags
  )
}

resource "aws_route_table" "public_internet_gateway" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = merge(
    {
      Name = "${var.project_name}-Public-RT"
    },
    local.standard_tags
  )
}

resource "aws_route_table" "private_nat_gateway" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw.id
  }

  tags = merge(
    {
      Name = "${var.project_name}-Private-RT"
    },
    local.standard_tags
  )
}

resource "aws_route_table_association" "private_subnets" {
  count          = 3
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_nat_gateway.id
}

resource "aws_route_table_association" "public_subnets" {
  count          = 3
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_internet_gateway.id
}
