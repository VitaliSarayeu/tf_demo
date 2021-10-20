resource "aws_subnet" "private" {
  count                   = 3
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 3, count.index)
  availability_zone       = data.aws_availability_zones.main_azs.names[count.index]
  map_public_ip_on_launch = false

  tags = merge(
    {
      Name = "${var.project_name}-${var.project_environment}-${data.aws_availability_zones.main_azs.names[count.index]}-private"
      Tier = "Private"
    },
    local.standard_tags,
    var.additional_private_subnet_tags
  )
}

resource "aws_subnet" "public" {
  count                   = 3
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 3, 3 + count.index)
  availability_zone       = data.aws_availability_zones.main_azs.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name = "${var.project_name}-${var.project_environment}-${data.aws_availability_zones.main_azs.names[count.index]}-public"
      Tier = "Public"
    },
    local.standard_tags,
    var.additional_public_subnet_tags
  )
}
