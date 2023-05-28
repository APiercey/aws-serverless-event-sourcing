###
#
# Function
#
###
module "get_cart" {
  source = "./lambda"

  source_dir = "../app"
  name       = "get_cart"
  runtime    = "ruby2.7"
  handler    = "functions/get_cart/main.handler"

  custom_policy_json = data.aws_iam_policy_document.get_cart_lambda_policy_data.json

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

data "aws_iam_policy_document" "get_cart_lambda_policy_data" {
  statement {
    effect = "Allow"

    actions = ["dynamodb:*"]

    resources = ["arn:aws:dynamodb:*:*:*"]
  }
}
