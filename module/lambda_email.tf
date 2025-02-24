resource "aws_s3_object" "mail_lambda_zip" {
  bucket = aws_s3_bucket.lambdabucket01.id
  key    = "lambdas/mail.zip"
  source    = "module/code/zip/mail.zip"
  etag = filemd5("module/code/zip/mail.zip")
}

resource "aws_lambda_function" "send_email" {
  function_name = "email"
  role          = aws_iam_role.SNSRole.arn
  runtime = "nodejs22.x"
  handler = "mail/mail.sendMail"
  s3_bucket = aws_s3_bucket.lambdabucket01.id
  s3_key = aws_s3_object.mail_lambda_zip.key
  source_code_hash = filebase64sha256("module/code/zip/mail.zip")
}

resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = aws_sqs_queue.UsersQueue.arn
  function_name = aws_lambda_function.send_email.arn
  batch_size = 1
  enabled = true
}