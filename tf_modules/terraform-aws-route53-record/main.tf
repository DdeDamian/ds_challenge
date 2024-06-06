# -------------------------------------------------------------------------------------------------------
# AWS Route53 records creation
# -------------------------------------------------------------------------------------------------------

resource "aws_route53_record" "record" {
  count   = var.create ? 1 : 0
  zone_id = var.zone_id
  name    = var.name
  type    = var.type
  ttl     = length(var.alias) > 0 ? null : var.ttl
  records = length(var.alias) > 0 ? null : var.records

  dynamic "alias" {
    for_each = var.alias
    content {
      name                   = alias.key
      zone_id                = alias.value.zone_id
      evaluate_target_health = true
    }
  }
}

