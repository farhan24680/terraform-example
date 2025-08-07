variable "aws_root_volume_size" {
  default     = 8
  type        = number
}

variable "aws_ami" {
  default     = "ami-0f58b397bc5c1f2e8"
  type        = string
}


variable "aws_region" {
  type    = string
  default = "ap-south-1"  # ✅ Region only!
}



variable "env" {
  description = "The environment for the deployment (e.g., dev, staging, prod)"
  type        = string
  default     = "prd"
}
