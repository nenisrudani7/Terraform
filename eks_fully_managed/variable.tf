variable "project_name" {
  type = string
}

variable "desired_size" {
  type = number
}

variable "min_size" {
  type = number

}
variable "public_subnet_az2_cidr" {}


variable "max_size" {
  type = number
}

# -----
variable "region" {}


variable "vpc_cidr" {}

variable "public_subnet_az1_cidr" {}

variable "private_subnet_az1_cidr" {}




variable "enable_nat_gateway" {
  type    = bool
  default = true
}

# variable "vpc_id" {
#   type = string
# }
