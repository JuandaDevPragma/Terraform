locals {
  create = {
    dbPolicy  = aws_iam_policy.DBRolePolicy.arn
    sqsPolicy = aws_iam_policy.SQSRolePolicy.arn
    logPolicy = aws_iam_policy.LogLambdaPolicy.arn
  }
  mail = {
    sqsPolicy = aws_iam_policy.SQSRolePolicy.arn
    snsPolicy = aws_iam_policy.SNSRolePolicy.arn
    logPolicy = aws_iam_policy.LogLambdaPolicy.arn
  }
  default= {
    dbPolicy  = aws_iam_policy.DBRolePolicy.arn
    logPolicy = aws_iam_policy.LogLambdaPolicy.arn
  }
}

resource "aws_iam_role_policy_attachment" "userCreateAttachment" {
  for_each   = local.create
  role       = aws_iam_role.CreateUserRole.name
  policy_arn = each.value
}

resource "aws_iam_role_policy_attachment" "userMailAttachment" {
  for_each   = local.mail
  role       = aws_iam_role.SNSRole.name
  policy_arn = each.value
}

resource "aws_iam_role_policy_attachment" "userDatabaseAttachment" {
  for_each = local.default
  policy_arn = each.value
  role       = aws_iam_role.DatabaseRole.name
}