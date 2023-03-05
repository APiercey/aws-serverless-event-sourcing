output "role_name" {
  value = aws_iam_role.iam_for_lambda.name
}

output "function_arn" {
  value = aws_lambda_function.main.arn
}

output "function_name" {
  value = var.name
}
