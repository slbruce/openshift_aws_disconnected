# VPC
resource "aws_vpc" "installation_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.vpc_prefix}vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.installation_vpc.id
  tags = {
    Name = "${var.vpc_prefix}igw"
  }
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.installation_vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.vpc_prefix}public-subnet"
  }
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.installation_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.vpc_prefix}public-route-table"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Private Subnet (Guest Machines)
resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.installation_vpc.id
  cidr_block = var.private_subnet_a_cidr
  tags = {
    Name = "${var.vpc_prefix}private-subnet-1"
  }
  availability_zone = "${var.region}a"
}

# Private Subnet (Guest Machines)
resource "aws_subnet" "private_subnet_2" {
  vpc_id     = aws_vpc.installation_vpc.id
  cidr_block = var.private_subnet_b_cidr
  tags = {
    Name = "${var.vpc_prefix}private-subnet-2"
  }
  availability_zone = "${var.region}b"
}

# Private Subnet (Guest Machines)
resource "aws_subnet" "private_subnet_3" {
  vpc_id     = aws_vpc.installation_vpc.id
  cidr_block = var.private_subnet_c_cidr
  tags = {
    Name = "${var.vpc_prefix}private-subnet-3"
  }
  availability_zone = "${var.region}c"
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
