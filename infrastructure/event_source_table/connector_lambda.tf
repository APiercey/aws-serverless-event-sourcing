###
#
# Function
#
###
module "dynamo_to_kinesis_connector" {
  source = "../lambda"

  source_dir = "event_source_table/scripts/dynamo_to_kinesis_connector"
  name = "${var.table_name}_to_kinesis_connector"
  runtime = "ruby2.7"
  handler = "main.handler"

  custom_policy_json = data.aws_iam_policy_document.dynamo_to_kinesis_lambda_policy_data.json

  variables = {
    # kinesis_event_stream = aws_kinesis_stream.all-event-stream.name
    kinesis_event_stream = var.kinesis_event_stream_name
  }
}

###
#
# Triggers
#
###

resource "aws_lambda_event_source_mapping" "example" {
  event_source_arn  = aws_dynamodb_table.es_table.stream_arn
  function_name     = module.dynamo_to_kinesis_connector.function_arn
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

