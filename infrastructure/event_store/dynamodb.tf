resource "aws_dynamodb_table" "es_table" {
  name     = "${var.name}-es-table"
  hash_key = "AggregateUuid"
  range_key = "Version"

  attribute {
    name = "AggregateUuid"
    type = "S"
  }

  attribute {
    name = "Version"
    type = "N"
  }

  read_capacity = 1
  write_capacity = 1

  stream_enabled = true
  stream_view_type = "NEW_IMAGE"
}

