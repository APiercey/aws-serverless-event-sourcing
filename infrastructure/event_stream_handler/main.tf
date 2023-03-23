data "aws_iam_policy_document" "lambda_and_kinesis_document" {
  statement {
    effect = "Allow"

    actions = ["kinesis:GetRecords", "kinesis:GetShardIterator", "kinesis:DescribeStream", "kinesis:ListShards", "kinesis:ListStreams"]

    # replace with kinesis_arn
    resources = ["arn:aws:kinesis:*"]
  }
}

resource "aws_iam_policy" "lambda_and_kinesis" {
  name        = "lambda_and_kinesis"
  path        = "/"
  description = "IAM policy for accessing Kinesis from a lambda"
  policy      = data.aws_iam_policy_document.lambda_and_kinesis_document.json
}

resource "aws_iam_role_policy_attachment" "lambda_kinesis_attachment" {
  role       = var.lambda_role_name
  policy_arn = aws_iam_policy.lambda_and_kinesis.arn
}

resource "aws_lambda_event_source_mapping" "mapping" {
  event_source_arn  = var.kinesis_arn
  function_name     = var.lambda_name
  starting_position = "LATEST"
}

