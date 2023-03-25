output "stream_name" {
  value = aws_kinesis_stream.all-event-stream.name
}

# Is this the same as above?
output "stream_arn" {
  value = aws_kinesis_stream.all-event.arn
}
