resource "aws_dynamodb_table" "shopping-carts-table" {
  name           = "ShoppingCarts"
  hash_key       = "Uuid"

  attribute {
    name = "Uuid"
    type = "S"
  }

  read_capacity = 1
  write_capacity = 1
}

