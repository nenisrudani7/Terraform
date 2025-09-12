variable "ec2_types" {
  default = "t2.micro"
  type    = string
}

variable "ec2_default_size" {
  default = 8
  type    = number
}
   

# environment varaible\
variable "env" {
  default = "production"
  type    = string
}
