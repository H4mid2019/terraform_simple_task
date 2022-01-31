resource "aws_elasticache_subnet_group" "cat_cache_subnet" {
  name       = "cat-cache-subnet"
  subnet_ids = ["${aws_subnet.subnet_private.id}"]
}

resource "aws_elasticache_cluster" "cluster_redis" {
  cluster_id           = "cluster-redis"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis6.x"
  port                 = 6379

  subnet_group_name  = aws_elasticache_subnet_group.cat_cache_subnet.name
  security_group_ids = ["${aws_security_group.lambda_security_group.id}", ]
}
