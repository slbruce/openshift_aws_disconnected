variable "vpc_prefix" {
  description = "Name of VPC"
  type = string
  default = "os-install-"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type = string
  default = "10.0.0.0/24"
}

variable "private_subnet_1_cidr" {
  description = "CIDR block for private subnet 1"
  type = string
  default = "10.0.0.128/28"
}

variable "private_subnet_2_cidr" {
  description = "CIDR block for private subnet 2"
  type = string
  default = "10.0.0.16/28"
}

variable "private_subnet_3_cidr" {
  description = "CIDR block for private subnet 3"
  type = string
  default = "10.0.0.32/28"
}

variable "cluster_name" {
  description = "The name of the cluster.  Will be subdomain of dns_domain"
  type = string
  default = "ocp4"
}