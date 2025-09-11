variable "env" {
  description = "environment for module infra"
  type = string
}

variable "bucket_name" {
  description = "this is bucket_name"
  type = string
}

variable "instance_number" {
    description = "this is the number of instance number"
    type = number
  
}

variable "instance_types" {
  description = "this is the instance types"
  type = string
}

variable "ami_types" {
  description = "this is the ami types"
  type = string 
}
variable "hash_key" {
  description = "enter hash keys "
}