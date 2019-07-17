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

resource "aws_iam_role" "iam_for_lambda" {
  name = "${random_id.project_name.hex}-iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "vault_lambda" {
  count            = var.enable ? 1 : 0
  filename         = data.archive_file.lambda.output_path
  function_name    = var.function_name
  role             = aws_iam_role.iam_for_lambda.arn
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
