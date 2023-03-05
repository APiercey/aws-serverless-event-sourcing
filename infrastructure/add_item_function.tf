###
#
# Function
#
###
module "add_item" {
  source = "./lambda"

  source_dir = "../app"
  name = "add_item"
  runtime = "ruby2.7"
  handler = "functions/add_item/main.handler"

  custom_policy_json = data.aws_iam_policy_document.add_item_lambda_policy_data.json

  variables = {}
}

###
#
# Triggers
#
###

# None

###
#
# IAM Permissions
#
###

data "aws_iam_policy_document" "add_item_lambda_policy_data" {
  statement {
   effect = "Allow"

   actions = ["dynamodb:*"]

   resources = ["arn:aws:dynamodb:*:*:*"]
  }
}
