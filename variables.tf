variable "region" {
  description = "The AWS region to deploy resources in"
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

variable "master0_ip" {
  description = "IP address of master0 node.  Has to be within the private_subnet_a_cidr range"
  type = string
  default = "10.0.0.132"
}

variable "master1_ip" {
  description = "IP address of master1 node.  Has to be within the private_subnet_b_cidr range"
  type = string
  default = "10.0.0.20"
}

variable "master2_ip" {
  description = "IP address of master1 node.  Has to be within the private_subnet_c_cidr range"
  type = string
  default = "10.0.0.36"
}