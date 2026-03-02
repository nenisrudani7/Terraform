variable "region" {
  default = "us-east-1"
  type    = string
}

variable "instance_type" {
  default = "t3.micro"
  type    = string
}

# Ubuntu 22.04 LTS (us-east-1)
variable "ubuntu_ami" {
  default = "ami-0fc5d935ebf8bc3bc"
  type    = string
}
