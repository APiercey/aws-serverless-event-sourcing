resource "aws_iam_policy" "lambda_custom_policy" {
  name        = "${var.name}-custom-policy-doc"
  path        = "/"
  description = "Custom Policy Document"
  policy      = var.custom_policy_json
}

resource "aws_iam_role_policy_attachment" "lambda_custom_policy_attachment" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_custom_policy.arn
}

