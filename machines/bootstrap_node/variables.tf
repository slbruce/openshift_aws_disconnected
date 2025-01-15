variable "bootstrap_type" {
  description = "The type of the bootstrap instance"
  type        = string
  default     = "t3.xlarge"
}

variable "bootstrap_volume_size" {
  description = "The volume size of the bootstrap instance"
  type        = number
  default     = 100
}

variable "bootstrap_ignition_sha" {
  description = "The SHA of the boostrap ignition file.  Needs to be calculated and provided"
  type = string
}