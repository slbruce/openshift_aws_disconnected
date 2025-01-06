# Security Group for Bastion Host
resource "aws_security_group" "bastion_sg" {
  vpc_id = aws_vpc.installation_vpc.id
  tags = {
    Name = "${var.vpc_prefix}bastion-sg"
  }
  description = "os-install-initial-sg"
}

output "bastion_sg_id" {
  value = aws_security_group.bastion_sg.id
}

resource "aws_vpc_security_group_egress_rule" "bastion_sg_egress" {
  security_group_id = aws_security_group.bastion_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "bastion_sg_ingress_22" {
  security_group_id = aws_security_group.bastion_sg.id
  cidr_ipv4         = var.bastion_security_group_ingress_cidr
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "bastion_sg_ingress_3389" {
  security_group_id = aws_security_group.bastion_sg.id
  cidr_ipv4         = var.bastion_security_group_ingress_cidr
  from_port         = 3389
  to_port           = 3389
  ip_protocol       = "tcp"
}

# Security Group for Registry
resource "aws_security_group" "registry_sg" {
  vpc_id = aws_vpc.installation_vpc.id
  tags = {
    Name = "${var.vpc_prefix}registry-sg"
  }
  description = "SG for registry"
}

output "registry_sg_id" {
  value = aws_security_group.registry_sg.id
}

resource "aws_vpc_security_group_egress_rule" "registry_sg_egress" {
  security_group_id = aws_security_group.registry_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "registry_sg_ingress_5000" {
  security_group_id = aws_security_group.registry_sg.id
  cidr_ipv4         = var.vpc_cidr
  from_port         = 5000
  to_port           = 5000
  ip_protocol       = "tcp"
  tags = {
    description = "Ingress for registry on port 5000"
  }
}

resource "aws_vpc_security_group_ingress_rule" "registry_sg_ingress_22_from_bastion" {
  security_group_id            = aws_security_group.registry_sg.id
  referenced_security_group_id = aws_security_group.bastion_sg.id
  from_port                    = 22
  to_port                      = 22
  ip_protocol                  = "tcp"
}

# Security Group for API Load Balancer
resource "aws_security_group" "api_lg_sg" {
  vpc_id = aws_vpc.installation_vpc.id
  tags = {
    Name = "${var.vpc_prefix}api-lb-sg"
  }
  description = "SG for cluster LB"
}

resource "aws_vpc_security_group_egress_rule" "api_lg_sg_egress" {
  security_group_id = aws_security_group.api_lg_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "registry_sg_ingress_22623_master0" {
  security_group_id = aws_security_group.api_lg_sg.id
  cidr_ipv4         = var.private_subnet_a_cidr
  from_port         = 22623
  to_port           = 22623
  ip_protocol       = "tcp"
  tags = {
    description = "Ingress from private subnet a"
  }
}

resource "aws_vpc_security_group_ingress_rule" "registry_sg_ingress_22623_master1" {
  security_group_id = aws_security_group.api_lg_sg.id
  cidr_ipv4         = var.private_subnet_b_cidr
  from_port         = 22623
  to_port           = 22623
  ip_protocol       = "tcp"
  tags = {
    description = "Ingress from private subnet b"
  }
}

resource "aws_vpc_security_group_ingress_rule" "registry_sg_ingress_22623_master2" {
  security_group_id = aws_security_group.api_lg_sg.id
  cidr_ipv4         = var.private_subnet_c_cidr
  from_port         = 22623
  to_port           = 22623
  ip_protocol       = "tcp"
  tags = {
    description = "Ingress from private subnet c"
  }
}

resource "aws_vpc_security_group_ingress_rule" "registry_sg_ingress_6443" {
  security_group_id = aws_security_group.api_lg_sg.id
  cidr_ipv4         = var.vpc_cidr
  from_port         = 6443
  to_port           = 6443
  ip_protocol       = "tcp"
  tags = {
    description = "Ingress from external sources"
  }
}

# Security Group for all-machine to all-machine communications
resource "aws_security_group" "all_machine_sg" {
  vpc_id = aws_vpc.installation_vpc.id
  tags = {
    Name = "${var.vpc_prefix}all_machine_sg"
  }
  description = "security group for all cluster communications"
}

resource "aws_vpc_security_group_egress_rule" "all_machine_sg_egress" {
  security_group_id = aws_security_group.all_machine_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "all_machine_sg_ingress_1936" {
  security_group_id            = aws_security_group.all_machine_sg.id
  referenced_security_group_id = aws_security_group.all_machine_sg.id
  from_port                    = 1936
  to_port                      = 1936
  ip_protocol                  = "tcp"
  description                  = "Metrics"
}

resource "aws_vpc_security_group_ingress_rule" "all_machine_sg_ingress_k8s_node_port_tcp" {
  security_group_id            = aws_security_group.all_machine_sg.id
  referenced_security_group_id = aws_security_group.all_machine_sg.id
  from_port                    = 30000
  to_port                      = 32767
  ip_protocol                  = "tcp"
  description                  = "Kubernetes node port"
}

resource "aws_vpc_security_group_ingress_rule" "all_machine_sg_ingress_reachability" {
  security_group_id            = aws_security_group.all_machine_sg.id
  referenced_security_group_id = aws_security_group.all_machine_sg.id
  ip_protocol                  = "icmp"
  from_port                    = 0
  to_port                      = 0

  description = "Network reachability tests"

}

resource "aws_vpc_security_group_ingress_rule" "all_machine_sg_ingress_host_level_services_tcp" {
  security_group_id            = aws_security_group.all_machine_sg.id
  referenced_security_group_id = aws_security_group.all_machine_sg.id
  from_port                    = 9000
  to_port                      = 9999
  ip_protocol                  = "tcp"

  description = "Host level services, including the node exporter on ports 9100-9101 and the Cluster Version Operator on port 9099."

}

resource "aws_vpc_security_group_ingress_rule" "all_machine_sg_ingress_k8s_node_port_udp" {
  security_group_id            = aws_security_group.all_machine_sg.id
  referenced_security_group_id = aws_security_group.all_machine_sg.id
  from_port                    = 30000
  to_port                      = 32767
  ip_protocol                  = "udp"

  description = "Kubernetes node port"

}

resource "aws_vpc_security_group_ingress_rule" "all_machine_sg_ingress_123" {
  security_group_id            = aws_security_group.all_machine_sg.id
  referenced_security_group_id = aws_security_group.all_machine_sg.id
  from_port                    = 123
  to_port                      = 123
  ip_protocol                  = "udp"

  description = "Network Time Protocol (NTP) on UDP port 123"

}

resource "aws_vpc_security_group_ingress_rule" "all_machine_sg_ingress_4500" {
  security_group_id            = aws_security_group.all_machine_sg.id
  referenced_security_group_id = aws_security_group.all_machine_sg.id
  from_port                    = 4500
  to_port                      = 4500
  ip_protocol                  = "udp"

  description = "IPsec NAT-T packets"

}

resource "aws_vpc_security_group_ingress_rule" "all_machine_sg_ingress_default" {
  security_group_id            = aws_security_group.all_machine_sg.id
  referenced_security_group_id = aws_security_group.all_machine_sg.id
  from_port                    = 10250
  to_port                      = 10259
  ip_protocol                  = "tcp"

  description = "The default ports that Kubernetes reserves"

}

resource "aws_vpc_security_group_ingress_rule" "all_machine_sg_ingress_vxlan" {
  security_group_id            = aws_security_group.all_machine_sg.id
  referenced_security_group_id = aws_security_group.all_machine_sg.id
  from_port                    = 4789
  to_port                      = 4789
  ip_protocol                  = "udp"

  description = "VXLAN"

}

resource "aws_vpc_security_group_ingress_rule" "all_machine_sg_ingress_ike" {
  security_group_id            = aws_security_group.all_machine_sg.id
  referenced_security_group_id = aws_security_group.all_machine_sg.id
  from_port                    = 500
  to_port                      = 500
  ip_protocol                  = "udp"

  description = "IPsec IKE packets"

}

resource "aws_vpc_security_group_ingress_rule" "all_machine_sg_ingress_host_level_services_udp" {
  security_group_id            = aws_security_group.all_machine_sg.id
  referenced_security_group_id = aws_security_group.all_machine_sg.id
  from_port                    = 9000
  to_port                      = 9999
  ip_protocol                  = "udp"

  description = "Host level services, including the node exporter on ports 9100-9101."

}

resource "aws_vpc_security_group_ingress_rule" "all_machine_sg_ingress_geneve" {
  security_group_id            = aws_security_group.all_machine_sg.id
  referenced_security_group_id = aws_security_group.all_machine_sg.id
  from_port                    = 6081
  to_port                      = 6081
  ip_protocol                  = "udp"

  description = "Geneve"

}

# Security Group for all-machine and control-plane to control-plane communications
resource "aws_security_group" "control_plane_sg" {
  vpc_id = aws_vpc.installation_vpc.id
  tags = {
    Name = "${var.vpc_prefix}control_plane_sg"
  }
  description = "SG For control plane"
}

resource "aws_vpc_security_group_egress_rule" "control_plane_sg_egress" {
  security_group_id = aws_security_group.control_plane_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "control_plane_sg_ingress_6443" {
  security_group_id            = aws_security_group.control_plane_sg.id
  referenced_security_group_id = aws_security_group.all_machine_sg.id
  from_port                    = 6443
  to_port                      = 6443
  ip_protocol                  = "tcp"

  description = "Kubernetes API for all-machine to control-plane"

}

resource "aws_vpc_security_group_ingress_rule" "control_plane_sg_ingress_etcd" {
  security_group_id            = aws_security_group.control_plane_sg.id
  referenced_security_group_id = aws_security_group.control_plane_sg.id
  from_port                    = 2379
  to_port                      = 2380
  ip_protocol                  = "tcp"

  description = "etcd server and peer ports"

}

# Security Group for application load balancer ingress (*.apps..")
resource "aws_security_group" "apps_lb_sg" {
  vpc_id = aws_vpc.installation_vpc.id
  tags = {
    Name = "${var.vpc_prefix}apps_lb_sg"
  }
  description = "sg for application ingress"
}

resource "aws_vpc_security_group_egress_rule" "apps_lb_sg_egress" {
  security_group_id = aws_security_group.apps_lb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "apps_lb_sg_ingress_80" {
  security_group_id = aws_security_group.apps_lb_sg.id
  cidr_ipv4         = var.vpc_cidr
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"

  description = "Port 80 for application ingress"

}

resource "aws_vpc_security_group_ingress_rule" "apps_lb_sg_ingress_443" {
  security_group_id = aws_security_group.apps_lb_sg.id
  cidr_ipv4         = var.vpc_cidr
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"

  description = "Port 443 for application ingress"
}
