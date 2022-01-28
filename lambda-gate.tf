locals {
  lambda_zip_location = "output/hello.zip"
}

data "archive_file" "hello" {
  type        = "zip"
  source_file = "hello.py"
  output_path = local.lambda_zip_location
}

resource "aws_lambda_function" "lambda" {
  filename      = data.archive_file.hello.output_path
  function_name = "hello"
  role          = aws_iam_role.lambda_role.arn
  handler       = "hello.lambda_handler"

  source_code_hash = data.archive_file.hello.output_base64sha256

  runtime = "python3.7"

  vpc_config {
    subnet_ids         = [aws_subnet.subnet_public.id]
    security_group_ids = [aws_default_security_group.default_security_group.id]
  }
}
