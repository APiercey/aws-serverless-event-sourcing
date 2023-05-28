resource "aws_lambda_event_source_mapping" "replay_queue_mapping" {
  event_source_arn = aws_sqs_queue.replay_queue.arn
  function_name    = var.lambda.function_arn
}

resource "aws_lambda_event_source_mapping" "mapping" {
  event_source_arn  = var.event_stream.stream_arn
  function_name    = var.lambda.function_arn
  starting_position = "AT_TIMESTAMP"
  starting_position_timestamp = "1985-01-01T00:00:00.00Z"
}

data "aws_iam_policy_document" "event_stream_handler_document" {
  statement {
    sid = "kinesis"
    effect = "Allow"

    actions = ["kinesis:GetRecords", "kinesis:GetShardIterator", "kinesis:DescribeStream", "kinesis:ListShards", "kinesis:ListStreams"]

    resources = [var.event_stream.stream_arn]
  }

  statement {
    sid = "sqs"
    effect = "Allow"

    actions = ["SQS:*"]

   resources = [aws_sqs_queue.replay_queue.arn]
  }

  statement {
    sid = "s3"
   effect = "Allow"

   actions = ["s3:*"]

   resources = ["arn:aws:s3::*:*"]
  }
}

resource "aws_iam_policy" "lambda_and_kinesis" {
  name        = "${var.lambda.function_name}-stream-handler"
  path        = "/"
  description = "${var.lambda.function_arn} Event Stream Handler"
  policy      = data.aws_iam_policy_document.event_stream_handler_document.json
}

resource "aws_iam_role_policy_attachment" "lambda_kinesis_attachment" {
  role       = var.lambda.role_name
  policy_arn = aws_iam_policy.lambda_and_kinesis.arn
}
