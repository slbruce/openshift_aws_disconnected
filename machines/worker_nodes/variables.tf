variable "compute_type" {
  description = "The type of a compute instance"
  type        = string
  default     = "t3.large"
}

variable "compute_size" {
  description = "The volume size of a compute instance"
  type        = number
  default     = 100
}

variable "compute_ignition_sha" {
  description = "The SHA of the compute ignition file.  Needs to be calculated and provided"
  type = string
}