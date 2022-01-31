resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "Stmt1643314639908"
        Action   = "logs:*"
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Sid = "Stmt1643497337398"
        Action = [
          "lambda:InvokeAsync",
          "lambda:InvokeFunction"
        ],
        Effect   = "Allow"
        Resource = aws_lambda_function.cat.arn
      }
    ]
  })
}


resource "aws_iam_role_policy" "cat_lambda_policy" {
  name = "cat_lambda_policy"
  role = aws_iam_role.cat_lambda_role.id
  policy = file("iam/cat-lambda-policy.json")
}

resource "aws_iam_role" "cat_lambda_role" {
  name = "cat_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
       {
          Effect = "Allow"
          Principal = {
             Service = "lambda.amazonaws.com"
          }
          Action = "sts:AssumeRole"
       }
    ]
 })


}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = file("iam/lambda-assume-role.json")
}


resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment_lambda_execution_access" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


