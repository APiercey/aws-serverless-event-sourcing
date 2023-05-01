###
#
# Kinesis Event Stream
#
###
resource "aws_kinesis_stream" "all-event-stream" {
  name        = "${var.name}-event_stream"
  shard_count = 1
}
