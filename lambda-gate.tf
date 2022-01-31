locals {
  lambda_zip_location = "output/hello.zip"
}

data "archive_file" "hello" {
  type        = "zip"
  source_file = "hello.py"
  output_path = local.lambda_zip_location
}

# data "archive_file" "cat" {
#   type        = "zip"
#   source_dir  = "cat/"
#   output_path = "output/cat.zip"
# }

# resource "null_resource" "install_python_dependencies" {
#   provisioner "local-exec" {
#     command = "bash ${path.module}/scripts/create_pkg.sh"

#     environment = {
#       source_code_path = "lambda_function"
#       function_name = "aws_lambda_test"
#       path_module = path.module
#       runtime = "python3.9"
#       path_cwd = path.cwd
#     }
#   }
# }

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
      REDIS_ADDRESS = aws_elasticache_cluster.cluster_redis.cache_nodes[0].address
      REDIS_PORT = aws_elasticache_cluster.cluster_redis.cache_nodes[0].port
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
