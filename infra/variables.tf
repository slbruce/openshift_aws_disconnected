variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "eu-west-1"
}

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

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type = string
  default = "10.0.0.0/28"
}

variable "private_subnet_a_cidr" {
  description = "CIDR block for private subnet a"
  type = string
  # to do change
  default = "10.0.0.128/25"
}

variable "private_subnet_b_cidr" {
  description = "CIDR block for private subnet b"
  type = string
  default = "10.0.0.16/28"
}

variable "private_subnet_c_cidr" {
  description = "CIDR block for private subnet c"
  type = string
  default = "10.0.0.32/28"
}

variable "bastion_security_group_ingress_cidr" {
  description = "Security Group ingress CIDR for bastion host"
  type = string
  default = "0.0.0.0/0"
}

variable "dns_domain" {
  description = "The domain that the cluster is installed"
  type = string
  default = "example.internal"
}

variable "cluster_name" {
  description = "The name of the cluster.  Will be subdomain of dns_domain"
  type = string
  default = "ocp4"
}