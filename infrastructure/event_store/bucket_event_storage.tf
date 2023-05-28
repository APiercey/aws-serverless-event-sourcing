resource "random_uuid" "uuid" {}

resource "aws_s3_bucket" "event-storage" {
  bucket = "${var.name}-${random_uuid.uuid.result}"
  force_destroy = true
}

