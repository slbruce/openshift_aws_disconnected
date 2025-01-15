locals {
  fqdn = "${var.cluster_name}.${data.terraform_remote_state.shared.outputs.dns_domain}"

  # Split by "/" to get "10.0.0.0"
  cidr_base = split("/", var.vpc_cidr)[0]
  # Split "10.0.0.0" by "." and remove the last part
  trimmed        = join(".", slice(split(".", local.cidr_base), 0, 3))
  reversed       = join(".", reverse(split(".", local.trimmed)))
  reverse_domain = "${local.reversed}-in-addr.arpa"
}

resource "aws_route53_zone" "primary" {
  name          = data.terraform_remote_state.shared.outputs.dns_domain
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

resource "aws_route53_zone" "reverse" {
  name          = local.reverse_domain
  comment       = "Reverse domain for OpenShift Internal Cluster"
  force_destroy = true

  vpc {
    vpc_id = aws_vpc.installation_vpc.id
  }
}

data "aws_network_interfaces" "lb_interfaces" {
  for_each = toset(aws_lb.api_lb.subnets)

  filter {
    name   = "subnet-id"
    values = [each.value]
  }

  filter {
    name   = "description"
    values = ["ELB ${regex(".+(net/.*/.*)", aws_lb.api_lb.arn)[0]}"]
  }
}

data "aws_network_interface" "lb_interface" {
  for_each = data.aws_network_interfaces.lb_interfaces

  id = each.value.ids[0]
}

resource "aws_route53_record" "api_lb_subnet_reverses" {
  for_each = data.aws_network_interface.lb_interface
  zone_id = aws_route53_zone.reverse.zone_id
  name    = "${slice(split(".", each.value.private_ip), 3, 4)[0]}.${local.reverse_domain}"
  type    = "PTR"
  ttl     = 300
  records = [aws_route53_record.api.fqdn, aws_route53_record.api-int.fqdn]
}