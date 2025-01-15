variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "eu-west-1"
}

variable "dns_domain" {
  description = "The domain that the cluster is installed"
  type = string
  default = "example.internal"
}

# this has been set for the coreos ami for 4.16.  To find a different AMI search for something similar to "rhcos-416.94.202410211619-0-x86_64"
# so rhcos-417 as an example.  You also have to subscribe to the os
variable "coreos_ami" {
  description = "The ami of the coreos instance"
  type        = string
  default     = "ami-0ce416143802f719b"
}