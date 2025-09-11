resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name = "${var.env}-infra-practise"
  #   billing_mode   = "PROVISIONED" means your service will open still it's not in use
  billing_mode = "PAY_PER_REQUEST"
  #   read_capacity  = 20
  #   write_capacity = 20
  hash_key = var.hash_key


  attribute {
    name = var.hash_key
    type = "S"
  }

  tags = {
    Name = "${var.env}-dynamodb-table-1"
    environment = var.env
  }
}