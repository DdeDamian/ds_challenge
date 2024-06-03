###########################
#           VPC           #
###########################
resource "aws_vpc" "default" {
  cidr_block           = var.cidr
  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  tags                 = merge(var.general_labels, var.vcp_labels)
}

###########################
#     Internet Gateway    #
###########################
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
  tags   = merge(var.general_labels, var.ig_labels)
}

###########################
#  EIP for NAT Gateway(s) #
###########################
resource "aws_eip" "nat_eip" {
  count  = var.enable_nat_gw ? local.nat_gw_count : 0
  domain = "vpc"
  tags   = merge(var.general_labels, var.nat_eip_labels)
}

###########################
#      NAT Gateway(s)     #
###########################
resource "aws_nat_gateway" "default" {
  count         = var.enable_nat_gw ? local.nat_gw_count : 0
  allocation_id = element(aws_eip.nat_eip.*.id, count.index)
  subnet_id     = element(aws_subnet.public_subnet.*.id, count.index)
  tags          = merge(var.general_labels, var.nat_gateway_labels)
}

###########################
#      Public subnet      #
###########################
resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnet)

  vpc_id                  = aws_vpc.default.id
  cidr_block              = var.public_subnet[count.index]
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = var.map_public_ip_on_launch
  tags                    = merge(var.general_labels, var.public_subnet_label)
}

###########################
#     Private subnet      #
###########################

resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnet)

  vpc_id                  = aws_vpc.default.id
  cidr_block              = var.private_subnet[count.index]
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = var.map_public_ip_on_launch
  tags                    = merge(var.general_labels, var.private_subnet_label)
}

###########################
#      Publiс routes      #
###########################
resource "aws_route_table" "public_routes" {
  count = length(var.public_subnet) > 0 ? 1 : 0

  vpc_id = aws_vpc.default.id
  tags   = merge(var.general_labels, var.public_routes_label)
}

resource "aws_route" "public_internet_gateway" {
  count = length(var.public_subnet) > 0 ? 1 : 0

  route_table_id         = aws_route_table.public_routes[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}

###########################
#      Private routes     #
###########################
resource "aws_route_table" "private_routes" {
  count = var.enable_nat_gw ? local.nat_gw_count : 1

  vpc_id = aws_vpc.default.id
  tags   = merge(var.general_labels, var.private_routes_label)
}

resource "aws_route" "nat_gw_route" {
  count = var.enable_nat_gw ? local.nat_gw_count : 0

  route_table_id         = element(aws_route_table.private_routes.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.default.*.id, count.index)
}

###########################
# Route table association #
###########################
resource "aws_route_table_association" "private" {
  count = length(var.private_subnet)

  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.private_routes.*.id, count.index)
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet)

  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_routes[0].id
}
