variable "control_plane_type" {
  description = "The type of a control plane instance"
  type        = string
  default     = "t3.xlarge"
}

variable "control_plane_size" {
  description = "The volume size of a control plane instance"
  type        = number
  default     = 100
}

variable "control_plane_ignition_sha" {
  description = "The SHA of the control plane ignition file.  Needs to be calculated and provided"
  type = string
}