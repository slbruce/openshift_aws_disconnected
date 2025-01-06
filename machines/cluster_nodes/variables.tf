# this has been set for the coreos ami for 4.16.  To find a different AMI search for something similar to "rhcos-416.94.202410211619-0-x86_64"
# so rhcos-417 as an example.  You also have to subscribe to the os
variable "coreos_ami" {
  description = "The ami of the coreos instance"
  type        = string
  default     = "ami-0ce416143802f719b"
}

# this should be set to false once the cluster is ready and the bootstrap can be destroyed
variable "bootstrap_needed" {
  description = "Whether the bootstrap machine is needed"
  type = bool
  default = false
}

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