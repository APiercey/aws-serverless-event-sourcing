###
#
# Function
#
###
module "s3_event_logger" {
  source = "./lambda"

  source_dir = "../app/functions/s3_event_logger"
  name = "s3_event_logger"
  runtime = "ruby2.7"
  handler = "functions/s3_event_logger/main.handler"

  custom_policy_json = data.aws_iam_policy_document.s3_logger_permissions_data.json

  variables = {
    s3_bucket_name = aws_s3_bucket.event-log.id
  }
}

###
#
# Triggers
#
###
module "s3_event_logger_kinesis_trigger" {
  source = "./kinesis_trigger"

  kinesis_arn = aws_kinesis_stream.all-event-stream.arn
  lambda_name = module.s3_event_logger.function_name
  lambda_role_name = module.s3_event_logger.role_name
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
