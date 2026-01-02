variable "region" {
  type = string
}


variable "env" {
  type = string
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

variable "ingress_cidr_blocks" {
  type = list(string)
}

variable "egress_cidr_blocks" {
  type = list(string)
}

variable "inbound_ports" {
  type = list(number)
}
# eks--------------
variable "cluster_name" {
  type = string
}