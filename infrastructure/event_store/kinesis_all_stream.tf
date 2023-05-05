###
#
# Kinesis Event Stream
#
###
resource "aws_kinesis_stream" "all-event-stream" {
  name        = "${var.name}-event-stream"
  shard_count = 1
}
