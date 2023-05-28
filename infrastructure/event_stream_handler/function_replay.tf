module "replay_function" {
  source = "../lambda"

  source_dir = "event_stream_handler/scripts/replay"
  name       = "${var.lambda.function_name}-replay-function"
  runtime = "ruby2.7"
  handler = "main.handler"

  custom_policy_json = data.aws_iam_policy_document.replay_lambda_document.json

  variables = {
    event_storage_bucket_name = var.event_stream.bucket_name
    replay_queue_url = aws_sqs_queue.replay_queue.url
  }
}

data "aws_iam_policy_document" "replay_lambda_document" {
  statement {
   sid = "1"
   effect = "Allow"

   actions = ["s3:*"]

   resources = ["arn:aws:s3::*:*"]
  }

  statement {
   sid = "2"
   effect = "Allow"

   actions = ["SQS:*"]

   resources = [aws_sqs_queue.replay_queue.arn]
  }
}
