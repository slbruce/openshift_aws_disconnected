# VPC
resource "aws_vpc" "installation_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.vpc_prefix}vpc"
  }
}

resource "aws_vpc_dhcp_options" "installation_vpc_dhcp_options" {
  domain_name = data.terraform_remote_state.shared.outputs.dns_domain
  domain_name_servers = ["AmazonProvidedDNS"]
}

resource "aws_vpc_dhcp_options_association" "installation_vpc_dhcp_options_association" {
  vpc_id          = aws_vpc.installation_vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.installation_vpc_dhcp_options.id
}

# Private Subnet
resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.installation_vpc.id
  cidr_block = var.private_subnet_1_cidr
  tags = {
    Name = "${var.vpc_prefix}private-subnet-1"
  }
  availability_zone = "${data.terraform_remote_state.shared.outputs.region}a"
}

# Private Subnet
resource "aws_subnet" "private_subnet_2" {
  vpc_id     = aws_vpc.installation_vpc.id
  cidr_block = var.private_subnet_2_cidr
  tags = {
    Name = "${var.vpc_prefix}private-subnet-2"
  }
  availability_zone = "${data.terraform_remote_state.shared.outputs.region}b"
}

# Private Subnet
resource "aws_subnet" "private_subnet_3" {
  vpc_id     = aws_vpc.installation_vpc.id
  cidr_block = var.private_subnet_3_cidr
  tags = {
    Name = "${var.vpc_prefix}private-subnet-3"
  }
  availability_zone = "${data.terraform_remote_state.shared.outputs.region}c"
}

# Private Route Table (No Internet Access)
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.installation_vpc.id
  tags = {
    Name = "${var.vpc_prefix}private-route-table"
  }
}

resource "aws_route_table_association" "private_subnet_association_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_subnet_association_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_subnet_association_3" {
  subnet_id      = aws_subnet.private_subnet_3.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_ec2_instance_connect_endpoint" "endpoint_for_bastion" {
  subnet_id = aws_subnet.private_subnet_2.id
  security_group_ids = [aws_security_group.instance_connect_ep_sg.id]
  preserve_client_ip = false
}
