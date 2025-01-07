variable "bastion_ami" {
  description = "The ami of the bastion instance"
  type        = string
  default     = "ami-009f51225716cb42f"
}

variable "bastion_type" {
  description = "The type of the bastion instance"
  type        = string
  default     = "t2.micro"
}

variable "bastion_key_name" {
  description = "The key name to ssh into the instance.  This should be already created"
  type        = string
  default     = "bastion_key"
}


variable "bastion_volume_size" {
  description = "The volume size of the bastion machine"
  type        = number
  default     = 80
}

variable "registry_ami" {
  description = "The ami of the registry instance"
  type        = string
  default     = "ami-009f51225716cb42f"
}

variable "registry_type" {
  description = "The type of the registry instance"
  type        = string
  default     = "t2.micro"
}

variable "registry_key_name" {
  description = "The key name to ssh into the instance.  This should be already created"
  type        = string
  default     = "bastion_key"
}


variable "registry_volume_size" {
  description = "The volume size of the bastion machine"
  type        = number
  default     = 80
}
