resource "aws_iam_policy" "SQSRolePolicy" {
  name = "SQSRolePolicy"
  policy = jsonencode({
    Version: "2012-10-17"
    Statement = [
      {
        Action: ["sqs:SendMessage", "sqs:ReceiveMessage", "sqs:GetQueueAttributes", "sqs:DeleteMessage"]
        Resource: "arn:aws:sqs:us-east-2:302263088688:UsersQueue"
        Effect: "Allow"
      }
    ]
  })
}

resource "aws_iam_policy" "SNSRolePolicy" {
  name = "SNSRolePolicy"
  policy = jsonencode({
    Version: "2012-10-17"
    Statement = [
      {
        Action: ["sns:Publish", "sns:Subscribe"]
        Resource: "arn:aws:sns:us-east-2:302263088688:UserSavedTopic"
        Effect: "Allow"
      }
    ]
  })
}

resource "aws_iam_policy" "DBRolePolicy" {
  name = "DBRolePolicy"
  policy = jsonencode({
    Version: "2012-10-17"
    Statement = [
      {
        Action: ["dynamodb:PutItem","dynamodb:GetItem","dynamodb:DeleteItem","dynamodb:UpdateItem","dynamodb:Scan","dynamodb:Query"]
        Resource: "arn:aws:dynamodb:us-east-2:302263088688:table/UsersTable"
        Effect: "Allow"
      }
    ]
  })
}

resource "aws_iam_policy" "LogLambdaPolicy" {
  name = "LogLambdaPolicy"
  policy = jsonencode({
    Version: "2012-10-17"
    Statement = [
      {
        Action: ["logs:CreateLogGroup","logs:CreateLogStream","logs:PutLogEvents"]
        Effect: "Allow"
        Resource = [
          "arn:aws:logs:us-east-2:302263088688:log-group:/aws/lambda/*:*:*"
        ]
      }
    ]
  })
}