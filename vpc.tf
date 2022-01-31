variable "vpc_cidr_block" {}
variable "subnet_public_cidr_block" {}
variable "subnet_private_cidr_block" {}


resource "aws_vpc" "lambda_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "lambda-vpc"
  }
}


resource "aws_subnet" "subnet_public" {
  vpc_id                  = aws_vpc.lambda_vpc.id
  cidr_block              = var.subnet_public_cidr_block
  map_public_ip_on_launch = true
  tags = {
    Name = "lambda-subnet-public"
  }
}


resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.lambda_vpc.id

  tags = {
    Name = "lambda-internet-gateway"
  }
}


resource "aws_route_table" "route_table_public" {
  vpc_id = aws_vpc.lambda_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "lambda-route-table-public"
  }
}

resource "aws_eip" "eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.internet_gateway]
  tags = {
    Name = "lambda-eip"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.subnet_public.id

  tags = {
    Name = "lambda-nat-gateway"
  }
}

resource "aws_route_table_association" "route_table_association_public" {
  subnet_id      = aws_subnet.subnet_public.id
  route_table_id = aws_route_table.route_table_public.id
}


resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment_lambda_vpc_access_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment_cat_lambda_vpc_access_execution" {
  role       = aws_iam_role.cat_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}


resource "aws_subnet" "subnet_private" {
  vpc_id                  = aws_vpc.lambda_vpc.id
  cidr_block              = var.subnet_private_cidr_block
  map_public_ip_on_launch = false
  tags = {
    Name = "lambda-subnet-private"
  }
}

resource "aws_route_table" "route_table_private" {
  vpc_id = aws_vpc.lambda_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "lambda-route-table-private"
  }
}

resource "aws_route_table_association" "route_table_association_private" {
  subnet_id      = aws_subnet.subnet_private.id
  route_table_id = aws_route_table.route_table_private.id
}
