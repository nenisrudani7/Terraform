resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name = "practise"
  #   billing_mode   = "PROVISIONED" means your service will open still it's not in use
  billing_mode = "PAY_PER_REQUEST"
  #   read_capacity  = 20
  #   write_capacity = 20
  hash_key = "LockID"


  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "dynamodb-table-1"

  }
}