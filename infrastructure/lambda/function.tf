data "archive_file" "lambda_archive" {
  type        = "zip"
  source_dir = var.source_dir
  output_path = "./packaged_functions/${var.name}.zip"
}

resource "aws_lambda_function" "main" {
  filename      = "./packaged_functions/${var.name}.zip"
  function_name = var.name
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = var.handler

  source_code_hash = data.archive_file.lambda_archive.output_base64sha256

  runtime = var.runtime

  timeout = 900

  environment {
    variables = var.variables
  }
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "${var.name}-role-for-lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

