output "vpc_ip" {
  value =   { for env, mod in module.vpc : env => mod.vpc_id }
}