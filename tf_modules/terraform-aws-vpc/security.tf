# --------------------------------------------------------------------
# Security settings (NACL rules)
# --------------------------------------------------------------------
#################
## Network ACL for public subnets
#################
resource "aws_network_acl" "public_subnet" {
  vpc_id     = aws_vpc.default.id
  subnet_ids = aws_subnet.public_subnet.*.id
  tags       = merge(var.general_labels, var.public_nacl_label)
}

#################
## public subnets ACL rule: allow traffic between subnets in the VPC
#################
resource "aws_network_acl_rule" "allow_private_inbound_vpc_traffic_publicsub" {
  network_acl_id = aws_network_acl.public_subnet.id
  rule_number    = 50
  egress         = false
  protocol       = -1
  from_port      = 0
  to_port        = 0
  cidr_block     = var.cidr
  rule_action    = "allow"
}

#################
## public subnets ACL rule: allow default and custom inbound traffic
#################
resource "aws_network_acl_rule" "allow_inbound_traffic_publicsub" {
  count          = length(local.inbound_traffic_pubsub)
  network_acl_id = aws_network_acl.public_subnet.id
  rule_number    = 100 + count.index * 10
  egress         = false
  protocol       = lookup(local.inbound_traffic_pubsub[count.index], "protocol")
  from_port      = lookup(local.inbound_traffic_pubsub[count.index], "from_port")
  to_port        = lookup(local.inbound_traffic_pubsub[count.index], "to_port")
  cidr_block     = lookup(local.inbound_traffic_pubsub[count.index], "source")
  rule_action    = "allow"
}

#################
## public subnets ACL rule: allow outbound traffic
#################
resource "aws_network_acl_rule" "allow_outbound_traffic_publicsub" {
  network_acl_id = aws_network_acl.public_subnet.id
  rule_number    = 50
  egress         = true
  protocol       = -1
  from_port      = 0
  to_port        = 0
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"
}

#################
## Network ACL for private subnets
#################
resource "aws_network_acl" "private_subnet" {
  vpc_id     = aws_vpc.default.id
  subnet_ids = flatten(local.all_private_subnet_ids)
  tags       = merge(var.general_labels, var.private_nacl_label)
}

#################
## private subnets ACL rule: allow traffic between subnets in the VPC
#################
resource "aws_network_acl_rule" "allow_private_inbound_vpc_traffic_privatesub" {
  network_acl_id = aws_network_acl.private_subnet.id
  rule_number    = 50
  egress         = false
  protocol       = -1
  from_port      = 0
  to_port        = 0
  cidr_block     = var.cidr
  rule_action    = "allow"
}

#################
## private subnets ACL rule: allow default and custom inbound traffic
#################
resource "aws_network_acl_rule" "allow_inbound_traffic_privatesub" {
  count          = length(local.inbound_traffic_privsub)
  network_acl_id = aws_network_acl.private_subnet.id
  rule_number    = 100 + count.index * 10
  egress         = false
  protocol       = lookup(local.inbound_traffic_privsub[count.index], "protocol")
  from_port      = lookup(local.inbound_traffic_privsub[count.index], "from_port")
  to_port        = lookup(local.inbound_traffic_privsub[count.index], "to_port")
  cidr_block     = lookup(local.inbound_traffic_privsub[count.index], "source")
  rule_action    = "allow"
}

#################
## private subnets ACL rule: allow outbound traffic
#################
resource "aws_network_acl_rule" "allow_outbound_traffic_privatesub" {
  network_acl_id = aws_network_acl.private_subnet.id
  rule_number    = 50
  egress         = true
  protocol       = -1
  from_port      = 0
  to_port        = 0
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"
}
