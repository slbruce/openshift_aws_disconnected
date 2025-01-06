locals {
  fqdn = "${var.cluster_name}.${var.dns_domain}"
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
  records = [var.bootstrap_ip]
}

resource "aws_route53_record" "master0" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "master0.${local.fqdn}"
  type    = "A"
  ttl     = 300
  records = [var.master0_ip]
}

resource "aws_route53_record" "master1" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "master1.${local.fqdn}"
  type    = "A"
  ttl     = 300
  records = [var.master1_ip]
}

resource "aws_route53_record" "master2" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "master2.${local.fqdn}"
  type    = "A"
  ttl     = 300
  records = [var.master2_ip]
}

resource "aws_route53_record" "worker0" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "worker0.${local.fqdn}"
  type    = "A"
  ttl     = 300
  records = [var.worker0_ip]
}

resource "aws_route53_record" "worker1" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "worker1.${local.fqdn}"
  type    = "A"
  ttl     = 300
  records = [var.worker1_ip]
}

resource "aws_route53_record" "registry" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "registry.${var.dns_domain}"
  type    = "A"
  ttl     = 300
  records = [var.registry_ip]
}
