resource "aws_dynamodb_table" "es_table" {
  name     = var.table_name
  hash_key = "Uuid"

  attribute {
    name = "Uuid"
    type = "S"
  }

  read_capacity = 1
  write_capacity = 1

  stream_enabled = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
}

