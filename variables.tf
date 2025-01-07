variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "eu-west-1"
}

variable "bastion_ip" {
  description = "IP address of registry node.  Has to be within the private_subnet_b_cidr range"
  type        = string
  default     = "10.0.0.25"
}

variable "registry_ip" {
  description = "IP address of registry node.  Has to be within the private_subnet_a_cidr range"
  type        = string
  default     = "10.0.0.134"
}

variable "bootstrap_ip" {
  description = "IP address of bootstrap node.  Has to be within the private_subnet_a_cidr range"
  type        = string
  default     = "10.0.0.133"
}

variable "master0_ip" {
  description = "IP address of master0 node.  Has to be within the private_subnet_a_cidr range"
  type        = string
  default     = "10.0.0.132"
}

variable "master1_ip" {
  description = "IP address of master1 node.  Has to be within the private_subnet_b_cidr range"
  type        = string
  default     = "10.0.0.20"
}

variable "master2_ip" {
  description = "IP address of master1 node.  Has to be within the private_subnet_c_cidr range"
  type        = string
  default     = "10.0.0.36"
}

variable "worker0_ip" {
  description = "IP address of worker0 node.  Has to be within the private_subnet_b_cidr range"
  type        = string
  default     = "10.0.0.22"
}

variable "worker1_ip" {
  description = "IP address of worker1 node.  Has to be within the private_subnet_c_cidr range"
  type        = string
  default     = "10.0.0.40"
}