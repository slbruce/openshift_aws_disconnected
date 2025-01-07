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
  # to do change
  default = "10.0.0.128/25"
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

variable "api_lb_subnet_1_ip" {
  description = "IP address of the api lb in subnet1"
  type        = string
  default     = "10.0.0.190"
}

variable "api_lb_subnet_2_ip" {
  description = "IP address of the api lb in subnet2"
  type        = string
  default     = "10.0.0.30"
}

variable "api_lb_subnet_3_ip" {
  description = "IP address of the api lb in subnet2"
  type        = string
  default     = "10.0.0.45"
}