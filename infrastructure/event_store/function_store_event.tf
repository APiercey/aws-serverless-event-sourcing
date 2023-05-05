###
#
# Function
#
###
module "function_store_event" {
  source = "../lambda"

  source_dir = "event_store/scripts/store_events"
  name = "store-events"
  runtime = "ruby2.7"
  handler = "main.handler"

  custom_policy_json = data.aws_iam_policy_document.s3_logger_permissions_data.json

  variables = {
    s3_bucket_name = aws_s3_bucket.event-storage.id
  }
}

###
#
# Triggers
#
###
data "aws_iam_policy_document" "lambda_and_kinesis_document" {
  statement {
    effect = "Allow"

    actions = ["kinesis:GetRecords", "kinesis:GetShardIterator", "kinesis:DescribeStream", "kinesis:ListShards", "kinesis:ListStreams"]

    # replace with kinesis_arn
    resources = ["arn:aws:kinesis:*"]
  }
}

resource "aws_iam_policy" "lambda_and_kinesis" {
  name        = "${var.name}_lambda_and_kinesis"
  path        = "/"
  description = "IAM policy for accessing Kinesis from a lambda"
  policy      = data.aws_iam_policy_document.lambda_and_kinesis_document.json
}

resource "aws_iam_role_policy_attachment" "lambda_kinesis_attachment" {
  role       = module.function_store_event.role_name
  policy_arn = aws_iam_policy.lambda_and_kinesis.arn
}

resource "aws_lambda_event_source_mapping" "mapping" {
  event_source_arn  = aws_kinesis_stream.all-event-stream.arn
  function_name     = module.function_store_event.function_name
  starting_position = "LATEST"
}

###
#
# IAM Permissions
#
###
data "aws_iam_policy_document" "s3_logger_permissions_data" {
  statement {
   effect = "Allow"

   actions = ["s3:*"]

   resources = ["arn:aws:s3::*:*"]
  }
}
