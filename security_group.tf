locals {
  ports_in = [
    6379,
    80,
    8080,
    443
  ]
  ports_out = [
    0
  ]
}


resource "aws_default_network_acl" "default_network_acl" {
  default_network_acl_id = aws_vpc.lambda_vpc.default_network_acl_id
  subnet_ids             = [aws_subnet.subnet_public.id, ]

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "lambda-default-network-acl"
  }
}

resource "aws_security_group" "lambda_security_group" {
  name   = "lambda_security_group"
  vpc_id = aws_vpc.lambda_vpc.id

  dynamic "ingress" {
    for_each = toset(local.ports_in)
    content {
      description = "open some useful ports"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "lambda-security-group"
  }
}
