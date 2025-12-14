variable "keyname" {
  type = string
}

variable "ami" {
  type = string
}
variable "type" {
  type = string
}
variable "subnets" {
  type = string
}
variable "security_groups" {
  type = list(string)
}
variable "associate_public_ip_address" {
  type = bool
}
variable "root_volume_size" {
  type = number
}
