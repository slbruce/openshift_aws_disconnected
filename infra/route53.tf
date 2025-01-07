locals {
  fqdn = "${var.cluster_name}.${var.dns_domain}"

  # Split by "/" to get "10.0.0.0"
  cidr_base = split("/", var.vpc_cidr)[0]
  # Split "10.0.0.0" by "." and remove the last part
  trimmed        = join(".", slice(split(".", local.cidr_base), 0, 3))
  reversed       = join(".", reverse(split(".", local.trimmed)))
  reverse_domain = "${local.reversed}-in-addr.arpa"
}

resource "aws_route53_zone" "primary" {
  name          = var.dns_domain
  comment       = "Main domain for OpenShift Internal Cluster"
  force_destroy = true

  vpc {
    vpc_id = aws_vpc.installation_vpc.id
  }
}

resource "aws_route53_record" "api-int" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "api-int.${local.fqdn}"
  type    = "A"

  alias {
    name                   = aws_lb.api_lb.dns_name
    zone_id                = aws_lb.api_lb.zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "api" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "api.${local.fqdn}"
  type    = "A"

  alias {
    name                   = aws_lb.api_lb.dns_name
    zone_id                = aws_lb.api_lb.zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "apps" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "*.apps.${local.fqdn}"
  type    = "A"

  alias {
    name                   = aws_lb.apps_ingress_lb.dns_name
    zone_id                = aws_lb.apps_ingress_lb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "bootstrap" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "bootstrap.${local.fqdn}"
  type    = "A"
  ttl     = 300
  records = [data.terraform_remote_state.shared.outputs.bootstrap_ip]
}

resource "aws_route53_record" "master0" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "master0.${local.fqdn}"
  type    = "A"
  ttl     = 300
  records = [data.terraform_remote_state.shared.outputs.master0_ip]
}

resource "aws_route53_record" "master1" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "master1.${local.fqdn}"
  type    = "A"
  ttl     = 300
  records = [data.terraform_remote_state.shared.outputs.master1_ip]
}

resource "aws_route53_record" "master2" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "master2.${local.fqdn}"
  type    = "A"
  ttl     = 300
  records = [data.terraform_remote_state.shared.outputs.master2_ip]
}

resource "aws_route53_record" "worker0" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "worker0.${local.fqdn}"
  type    = "A"
  ttl     = 300
  records = [data.terraform_remote_state.shared.outputs.worker0_ip]
}

resource "aws_route53_record" "worker1" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "worker1.${local.fqdn}"
  type    = "A"
  ttl     = 300
  records = [data.terraform_remote_state.shared.outputs.worker1_ip]
}

resource "aws_route53_record" "registry" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "registry.${var.dns_domain}"
  type    = "A"
  ttl     = 300
  records = [data.terraform_remote_state.shared.outputs.registry_ip]
}

resource "aws_route53_zone" "reverse" {
  name          = local.reverse_domain
  comment       = "Reverse domain for OpenShift Internal Cluster"
  force_destroy = true

  vpc {
    vpc_id = aws_vpc.installation_vpc.id
  }
}

resource "aws_route53_record" "master0_reverse" {
  zone_id = aws_route53_zone.reverse.zone_id
  name    = "${slice(split(".", data.terraform_remote_state.shared.outputs.master0_ip), 3, 4)[0]}.${local.reverse_domain}"
  type    = "PTR"
  ttl     = 300
  records = [aws_route53_record.master0.fqdn]
}

resource "aws_route53_record" "master1_reverse" {
  zone_id = aws_route53_zone.reverse.zone_id
  name    = "${slice(split(".", data.terraform_remote_state.shared.outputs.master1_ip), 3, 4)[0]}.${local.reverse_domain}"
  type    = "PTR"
  ttl     = 300
  records = [aws_route53_record.master1.fqdn]
}

resource "aws_route53_record" "master2_reverse" {
  zone_id = aws_route53_zone.reverse.zone_id
  name    = "${slice(split(".", data.terraform_remote_state.shared.outputs.master2_ip), 3, 4)[0]}.${local.reverse_domain}"
  type    = "PTR"
  ttl     = 300
  records = [aws_route53_record.master2.fqdn]
}

resource "aws_route53_record" "bootstrap_reverse" {
  zone_id = aws_route53_zone.reverse.zone_id
  name    = "${slice(split(".", data.terraform_remote_state.shared.outputs.bootstrap_ip), 3, 4)[0]}.${local.reverse_domain}"
  type    = "PTR"
  ttl     = 300
  records = [aws_route53_record.bootstrap.fqdn]
}

resource "aws_route53_record" "worker0_reverse" {
  zone_id = aws_route53_zone.reverse.zone_id
  name    = "${slice(split(".", data.terraform_remote_state.shared.outputs.worker0_ip), 3, 4)[0]}.${local.reverse_domain}"
  type    = "PTR"
  ttl     = 300
  records = [aws_route53_record.worker0.fqdn]
}

resource "aws_route53_record" "worker1_reverse" {
  zone_id = aws_route53_zone.reverse.zone_id
  name    = "${slice(split(".", data.terraform_remote_state.shared.outputs.worker1_ip), 3, 4)[0]}.${local.reverse_domain}"
  type    = "PTR"
  ttl     = 300
  records = [aws_route53_record.worker1.fqdn]
}

resource "aws_route53_record" "api_lb_subnet1_reverse" {
  zone_id = aws_route53_zone.reverse.zone_id
  name    = "${slice(split(".", var.api_lb_subnet_1_ip), 3, 4)[0]}.${local.reverse_domain}"
  type    = "PTR"
  ttl     = 300
  records = [aws_route53_record.api.fqdn, aws_route53_record.api-int.fqdn]
}

resource "aws_route53_record" "api_lb_subnet2_reverse" {
  zone_id = aws_route53_zone.reverse.zone_id
  name    = "${slice(split(".", var.api_lb_subnet_2_ip), 3, 4)[0]}.${local.reverse_domain}"
  type    = "PTR"
  ttl     = 300
  records = [aws_route53_record.api.fqdn, aws_route53_record.api-int.fqdn]
}

resource "aws_route53_record" "api_lb_subnet3_reverse" {
  zone_id = aws_route53_zone.reverse.zone_id
  name    = "${slice(split(".", var.api_lb_subnet_3_ip), 3, 4)[0]}.${local.reverse_domain}"
  type    = "PTR"
  ttl     = 300
  records = [aws_route53_record.api.fqdn, aws_route53_record.api-int.fqdn]
}