data "archive_file" "lambda" {
  type        = "zip"
  output_path = "${path.module}/lambda.zip"

  dynamic "source" {
    for_each = var.source_files
    content {
      filename = subnet.key
      content  = subnet.value
    }
  }
}

resource "aws_lambda_function" "vault_lambda" {
  count            = var.enable ? 1 : 0
  filename         = data.archive_file.lambda.output_path
  function_name    = var.function_name
  role             = var.aws_iam_role
  handler          = "lambda_function.lambda_handler"
  source_code_hash = "${base64sha256(file("${data.archive_file.lambda.output_path}"))}"
  runtime          = var.runtime
  timeout          = var.timeout
  memory_size      = var.memory_size
  tags             = var.tags

  environment {
    variables = {
      for key in var.environment_variables :
      key => key.value
    }
  }
}
