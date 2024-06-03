locals {
  nat_gw_count            = var.single_nat_gw ? 1 : length(var.azs)
  inbound_traffic_pubsub  = concat(var.allow_inbound_traffic_default_publicsub, var.allow_inbound_traffic_publicsub)
  inbound_traffic_privsub = concat(var.allow_inbound_traffic_default_privatesub, var.allow_inbound_traffic_privatesub)
  all_private_subnet_ids  = concat(aws_subnet.private_subnet.*.id)
}
