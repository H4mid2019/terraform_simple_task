locals {
  lambda_zip_location = "output/hello.zip"
}

data "archive_file" "hello" {
  type        = "zip"
  source_file = "hello.py"
  output_path = local.lambda_zip_location
}

resource "aws_lambda_function" "cat" {
  filename      = "cat/cat_lambda.zip"
  function_name = "cat"
  role          = aws_iam_role.cat_lambda_role.arn
  handler       = "cat.lambda_handler"

  source_code_hash = filebase64sha256("cat/cat_lambda.zip")

  runtime = "python3.9"

  vpc_config {
    subnet_ids         = [aws_subnet.subnet_private.id]
    security_group_ids = [aws_security_group.lambda_security_group.id]
  }
  environment {
    variables = {
      REDIS_ADDRESS   = aws_elasticache_cluster.cluster_redis.cache_nodes[0].address
      REDIS_PORT      = aws_elasticache_cluster.cluster_redis.cache_nodes[0].port
      DYNAMO_DB_TABLE = aws_dynamodb_table.cat.name
    }
  }


}
resource "aws_lambda_function" "lambda" {
  filename      = data.archive_file.hello.output_path
  function_name = "hello"
  role          = aws_iam_role.lambda_role.arn
  handler       = "hello.lambda_handler"

  source_code_hash = data.archive_file.hello.output_base64sha256

  runtime = "python3.9"
  environment {
    variables = {
      CAT_LAMBDA = aws_lambda_function.cat.arn
    }
  }
}
