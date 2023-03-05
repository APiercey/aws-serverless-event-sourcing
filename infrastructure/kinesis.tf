###
#
# Kinesis Event Stream
#
###
resource "aws_kinesis_stream" "all-event-stream" {
  name        = "event_stream"
  shard_count = 1
}

###
#
# Sources
#
###
resource "aws_dynamodb_kinesis_streaming_destination" "shopping_cart_to_event_stream" {
  stream_arn = aws_kinesis_stream.all-event-stream.arn
  table_name = aws_dynamodb_table.shopping-carts-table.name
}

