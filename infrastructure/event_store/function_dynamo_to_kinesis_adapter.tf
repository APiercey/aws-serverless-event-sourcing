###
#
# Function
#
###
module "dynamo_to_kinesis_adapter" {
  source = "../lambda"

  source_dir = "event_store/scripts/dynamo_to_kinesis_adapter"
  name = "${var.name}_to_kinesis_adapter"
  runtime = "ruby2.7"
  handler = "main.handler"

  custom_policy_json = data.aws_iam_policy_document.dynamo_to_kinesis_lambda_policy_data.json

  variables = {
    kinesis_event_stream = aws_kinesis_stream.all-event-stream.name
  }
}

###
#
# Triggers
#
###

resource "aws_lambda_event_source_mapping" "example" {
  event_source_arn  = aws_dynamodb_table.es_table.stream_arn
  function_name     = module.dynamo_to_kinesis_adapter.function_arn
  starting_position = "LATEST"
}

###
#
# IAM Permissions
#
###
data "aws_iam_policy_document" "dynamo_to_kinesis_lambda_policy_data" {
  statement {
   effect = "Allow"

   actions = ["dynamodb:DescribeStream", "dynamodb:GetRecords", "dynamodb:GetShardIterator", "dynamodb:ListStreams"]

   resources = ["arn:aws:dynamodb:*:*:*"]
  }

  statement {
    effect = "Allow"

    actions = ["kinesis:PutRecords", "kinesis:PutRecord"]

    # replace with kinesis_arn
    resources = ["arn:aws:kinesis:*"]
  }
}

