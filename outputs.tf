output "aws_iam_role" {
  value = aws_iam_role.iam_for_lambda.id
}

output "arn" {
  value = length(aws_lambda_function.vault_lambda) > 0 ? aws_lambda_function.vault_lambda[0].arn : "Lambda not created"
}

output "invoke_arn" {
  value = length(aws_lambda_function.vault_lambda) > 0 ? aws_lambda_function.vault_lambda[0].invoke_arn : "Lambda not created"
}
