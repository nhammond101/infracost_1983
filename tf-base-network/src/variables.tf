# -----------------------------------------------------------------------------
# Variables: General
# -----------------------------------------------------------------------------
variable "name_prefix" {
  description = "The value to prefix resources with"
  type        = string
  default     = ""
}

variable "region" {
  type        = string
  default     = "us-east-2"
  description = "The fallback region to deploy the resources into"
}

# -----------------------------------------------------------------------------
# Variables: VPC
# -----------------------------------------------------------------------------

variable "vpc_cidr" {
  description = "The CIDR for the VPC"
  default     = "10.0.0.0/16"
  type        = string
}

variable "subnet_count" {
  type        = number
  description = "The number of public/private subnets to create.  Limited to the maximum number of Availability Zones in the region"
  default     = 3
}

variable "single_nat" {
  default     = false
  description = "Creates a single NAT Gateway used by *all* private subnets created"
  type        = bool
}
