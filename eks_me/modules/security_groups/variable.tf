variable "env" {
 type= string
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

variable "vpc_id" {
  type = string
}
