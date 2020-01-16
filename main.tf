data "local_file" "lambda" {
  count    = length(var.source_files)
  filename = element(var.source_files, count.index).filename
}

data "archive_file" "lambda" {
  type        = "zip"
  output_path = "${path.module}/lambda.zip"

  dynamic "source" {
    for_each = var.source_files
    content {
      filename = source.value["filename"]
      content  = data.local_file.lambda[index(data.local_file.lambda.*.filename, source.value["filename"])].content
    }
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "${var.function_name}-iam_for_lambda"

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
  handler          = var.handler
  source_code_hash = filebase64sha256("${data.archive_file.lambda.output_path}")
  runtime          = var.runtime
  timeout          = var.timeout
  memory_size      = var.memory_size
  tags             = var.tags
  vpc_config {
    subnet_ids = var.subnet_ids
    security_group_ids = var.security_group_ids
   }

  environment {
    variables = var.environment_variables
  }
}
