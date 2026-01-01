variable "env" {
 type= string
}

variable "cidr_block_vpc" {
  type = string
}

variable "cidr_block_sn1" {
  type = list(string)
}
variable "availability_zone" {
  type = list(string)
}

variable "cidr_block_route" {
  type = string
}