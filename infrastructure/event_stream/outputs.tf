output "stream_name" {
  value = aws_kinesis_stream.all-event-stream.name
}

# Is this the same as above?
output "stream_arn" {
  value = aws_kinesis_stream.all-event-stream.arn
}

output "bucket_name" {
  value = aws_s3_bucket.event-storage.id
}
