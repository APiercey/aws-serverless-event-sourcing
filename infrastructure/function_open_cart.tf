###
#
# Function
#
###
module "open_cart" {
  source = "./lambda"

  source_dir = "../app"
  name       = "open_cart"
  runtime    = "ruby2.7"
  handler    = "functions/open_cart/main.handler"

  custom_policy_json = data.aws_iam_policy_document.open_cart_lambda_policy_data.json

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

data "aws_iam_policy_document" "open_cart_lambda_policy_data" {
  statement {
    effect = "Allow"

    actions = ["dynamodb:*"]

    resources = ["arn:aws:dynamodb:*:*:*"]
  }
}
