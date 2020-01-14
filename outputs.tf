output "aws_iam_role" {
  value = aws_iam_role.iam_for_lambda.arn
}

output "arn" {
  value = aws_lambda_function.vault_lambda[0].arn
}

output "invoke_arn" {
  value = aws_lambda_function.vault_lambda[0].invoke_arn
}
