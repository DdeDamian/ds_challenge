module "hello_ds_record" {
  source = "./../../tf_modules/terraform-aws-route53-record/"

  # AWS provider settings
  providers = {
    aws = aws.environment
  }

  name    = "hello.dschallenge.de"
  create  = true
  zone_id = "Z08419191AU8M6MF4XTSR"
  type    = "CNAME"
  ttl     = 300
  records = ["a47de2077ca534dffaefff3f5f85fbde-370963872.eu-central-1.elb.amazonaws.com"]
  alias   = {}
}

module "ds_certification_record" {
  source = "./../../tf_modules/terraform-aws-route53-record/"

  # AWS provider settings
  providers = {
    aws = aws.environment
  }

  name    = "_8fe9d193f12360003916cf4135fd62ab.dschallenge.de"
  create  = true
  zone_id = "Z08419191AU8M6MF4XTSR"
  type    = "CNAME"
  ttl     = 300
  records = ["_c7f3a7b5fd22b4409a1e43c32b509954.sdgjtdhdhz.acm-validations.aws."]
  alias   = {}
}
