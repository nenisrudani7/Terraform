variable "project_name" {
  
}

variable "module_name" {
  type = string
}

variable "subnet_ids" {}

variable "instance_type" {
  type = list(string) 
}


variable "desired_size" {
  type    = number
  default = 3
}

variable "min_size" {
  type    = number
  default = 3
}

variable "max_size" {
  type    = number
  default = 4
}

variable "usage_label" {
  type = string
}

variable "eks_version" {

}

variable "nodegroup_subnet_ids" {
  type = list(string)
}
variable "eks_public_access_cidrs" {
  description = "CIDR blocks allowed to access EKS public endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # Office IP
}