module "d-infra" {
  source          = "./infra_app"
  env             = "development"
  bucket_name     = "d1234"
  instance_number = 1
  instance_types  = "t2.micro"
  ami_types       = "ami-0360c520857e3138f"
  hash_key        = "lock_keys"

}

module "p-infra" {
  source          = "./infra_app"
  env             = "production"
  bucket_name     = "d12342"
  instance_number = 1
  instance_types  = "t2.micro"
  ami_types       = "ami-0360c520857e3138f"
  hash_key        = "lock_keys"

}
module "s-infra" {
  source          = "./infra_app"
  env             = "staging_area"
  bucket_name     = "d12343"
  instance_number = 1
  instance_types  = "t2.micro"
  ami_types       = "ami-0360c520857e3138f"
  hash_key        = "lock_keys"

}