resource "aws_iam_role" "CreateUserRole" {
  name = "CreateUserRole"
  assume_role_policy = jsonencode({
    Version: "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role" "DatabaseRole" {
  name = "DatabaseRole"
  assume_role_policy = jsonencode({
    Version: "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role" "SNSRole" {
  name = "SNSRole"
  assume_role_policy = jsonencode({
    Version: "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}