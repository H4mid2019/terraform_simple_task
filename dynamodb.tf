resource "aws_dynamodb_table" "cat" {
  name             = "cat"
  hash_key         = "CatFactHashKey"
  billing_mode     = "PAY_PER_REQUEST"
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "CatFactHashKey"
    type = "S"
  }
}