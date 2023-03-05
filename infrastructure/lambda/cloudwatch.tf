resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${var.name}"

  retention_in_days = 1

  lifecycle {
    prevent_destroy = false
  }
}

data "aws_iam_policy_document" "log_policy_data" {
  statement {
    effect = "Allow"

    actions = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]

    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_policy" "log_policy" {
  name        = "${var.name}_log_policy"
  path        = "/"
  description = "IAM policy for accessing Kinesis from a lambda"
  policy      = data.aws_iam_policy_document.log_policy_data.json
}

resource "aws_iam_role_policy_attachment" "log_policy_attachment" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.log_policy.arn
}

