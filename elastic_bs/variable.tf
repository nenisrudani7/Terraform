variable "region" {
  description = "Please state the region"
  default     = "us-east-1"
}

variable "language" {
  description = "Please state the programming language"
  default     = "Node.js"
}

variable "vpc_id" {
  description = "ID of the VPC where the Elastic Beanstalk environment will be deployed"
  default     = "vpc-00fa2c67b20057328" #Edit it with your VPC ID
}

variable "subnet" {
  description = "Subnet ID of first zone"
  default     = ["subnet-03c64336dbc59d3d3", "subnet-024117b4a50af80cc"] #Edit it with your subnet ids

}

variable "instance_type" {
  description = "t2.micro"
  default = "t2.micro"

}

variable "solution_stack_name" {
#   default = "Node.js 22 running on 64bit Amazon Linux 2023"
default = "64bit Amazon Linux 2023 v6.6.1 running Node.js 22"

}

variable "app_zip_path" {
  description = "Path to your application ZIP file"
  default     = "/home/nenis/work/terraform_practise/elastic_bs/zip/index.zip"
  }

