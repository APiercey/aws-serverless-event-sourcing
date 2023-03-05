resource "random_uuid" "uuid" {}

resource "aws_s3_bucket" "event-log" {
  bucket = "event-log-${random_uuid.uuid.result}"
  force_destroy = true
}

