variable "bastion_key_name" {
  description = "A pre-existing key that will be used to connect to the bastion using Instance Connect Endpoint"
  type = string
}

variable "registry_key_name" {
  description = "A pre-existing key that will be used to connect to the registry from the bastion machine.  You will have to upload the private key to the bastion machine once it has been created"
  type = string
}

variable "bastion_ami" {
  description = "The ami of the bastion instance"
  type        = string
  ## this is the fedora cloud instance available in eu-west-1
  ## see https://fedoraproject.org/cloud/download#cloud_launch for up-to-date list
  default     = "ami-0808759460bb0688c"
}

variable "bastion_type" {
  description = "The type of the bastion instance"
  type        = string
  default     = "t2.micro"
}

variable "bastion_volume_size" {
  description = "The volume size of the bastion machine"
  type        = number
  default     = 30
}

variable "registry_ami" {
  description = "The ami of the registry instance"
  type        = string
  default     = "ami-0808759460bb0688c"
}

variable "registry_type" {
  description = "The type of the registry instance"
  type        = string
  default     = "t2.micro"
}

variable "registry_volume_size" {
  description = "The volume size of the bastion machine"
  type        = number
  default     = 80
}
