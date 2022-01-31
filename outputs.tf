output "base_url" {
  # description = "Base URL for API Gateway stage."
  value = "${aws_apigatewayv2_stage.lambda.invoke_url}/hello"
}


output "redis_endpoint_address" {
  value = aws_elasticache_cluster.cluster_redis.cache_nodes[0].address
}

output "aws_dynamodb_table_arn" {
  value = aws_dynamodb_table.cat.arn
}
