### Lambda Role #####

resource "aws_iam_role" "cw_lambda_role" {
  name = "cw-lambda-role-for-retention-period"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

}

### Lambda Permissions #####

resource "aws_iam_policy" "cw_lambda_policy" {
  name        = "cw-lambda-policy-for-retention-period"
  path        = "/"
  description = "put the description here"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogStream",
          "logs:PutRetentionPolicy",
          "logs:CreateLogGroup",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups"
        ],
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

# Policy Attachment 
resource "aws_iam_role_policy_attachment" "cw_lambda_role_policy_attachment" {
  role       = aws_iam_role.cw_lambda_role.name
  policy_arn = aws_iam_policy.cw_lambda_policy.arn
}