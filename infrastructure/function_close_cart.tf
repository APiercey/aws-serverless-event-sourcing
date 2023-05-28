###
#
# Function
#
###
module "close_cart" {
  source = "./lambda"

  source_dir = "../app"
  name       = "close_cart"
  runtime    = "ruby2.7"
  handler    = "functions/close_cart/main.handler"

  custom_policy_json = data.aws_iam_policy_document.close_cart_lambda_policy_data.json

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

data "aws_iam_policy_document" "close_cart_lambda_policy_data" {
  statement {
    effect = "Allow"

    actions = ["dynamodb:*"]

    resources = ["arn:aws:dynamodb:*:*:*"]
  }
}
