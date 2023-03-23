module "shopping-carts-table" {
  source = "./event_source_table"

  table_name = "ShoppingCarts"
  kinesis_event_stream_name = module.all_event_stream.stream_name
}
