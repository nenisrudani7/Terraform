variable "region" {
  type        = string
  description = "AWS region"
}

variable "environment" {
  type        = string
  description = "Deployment environment"
}

variable "tags" {
  type        = map(string)
  description = "Common resource tags"
}

# VPC Variables
variable "vpc_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "intra_subnets" {
  type = list(string)
}

# EKS Variables
variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "eks_addon_versions" {
  type = map(string)
}

# Security Group


variable "instance_type" {
  type = string
}
