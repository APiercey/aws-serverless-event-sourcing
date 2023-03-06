module "shopping-carts-table" {
  source = "./event_source_table"

  table_name = "ShoppingCarts"
  kinesis_event_stream_name = aws_kinesis_stream.all-event-stream.name
}
