resource "aws_key_pair" "keys" {
  key_name   = var.key_name
  public_key = file(var.key_path)
  
  tags = {
    environment = "bastionhost"
  }
}