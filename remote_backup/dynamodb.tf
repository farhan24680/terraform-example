resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "terraform_practice_abc"
  billing_mode   = "PAY_PER_REQUEST"
   hash_key       = "LockID"
  
  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "terraform_practice_abc"
  }
}