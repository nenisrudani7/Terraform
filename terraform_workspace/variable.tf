variable "env" {
  default = "dev" #dev ennvironment if you wnat to set production then use prd instead of dev
}
locals {
  volume_size = "8"
}