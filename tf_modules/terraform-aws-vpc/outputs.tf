#######
# VPC
#######
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.default.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.default.cidr_block
}

output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = aws_vpc.default.default_security_group_id
}

# Subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private_subnet.*.id
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = aws_subnet.private_subnet.*.cidr_block
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public_subnet.*.id
}

output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = aws_subnet.public_subnet.*.cidr_block
}

output "database_subnets" {
  description = "List of IDs for DB subnets"
  value       = aws_subnet.database_subnet.*.id
}

output "database_subnets_azs" {
  description = "List of the AZ for the subnet"
  value       = aws_subnet.database_subnet.*.availability_zone
}

##############
# Route tables
##############

output "public_route_table_ids" {
  description = "List of IDs of public route tables"
  value       = aws_route_table.public_routes.*.id
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = aws_route_table.private_routes.*.id
}

output "nat_ids" {
  description = "List of allocation ID of Elastic IPs created for AWS NAT Gateway"
  value       = aws_eip.nat_eip.*.id
}

output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = aws_eip.nat_eip.*.public_ip
}

output "nat_gw_ids" {
  description = "List of NAT Gateway IDs"
  value       = aws_nat_gateway.default.*.id
}

##################
# Internet Gateway
##################
output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = element(concat(aws_internet_gateway.default.*.id, tolist([])), 0)
}
