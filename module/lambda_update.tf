resource "aws_api_gateway_method" "update_user" {
  http_method   = "PUT"
  resource_id   = aws_api_gateway_resource.update-user-id.id
  rest_api_id   = aws_api_gateway_rest_api.iac_api.id
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "update_user_lambda" {
  integration_http_method = "POST"
  http_method = aws_api_gateway_method.update_user.http_method
  resource_id = aws_api_gateway_resource.update-user-id.id
  rest_api_id = aws_api_gateway_rest_api.iac_api.id
  type        = "AWS_PROXY"
  uri = aws_lambda_function.update_user.invoke_arn
}

resource "aws_s3_object" "update_lambda_zip" {
  bucket = aws_s3_bucket.lambdabucket01.id
  key    = "lambdas/update.zip"
  source    = "module/code/zip/update.zip"
  etag = filemd5("module/code/zip/update.zip")
}

resource "aws_lambda_function" "update_user" {
  function_name = "update"
  role          = aws_iam_role.DatabaseRole.arn
  runtime = "nodejs22.x"
  handler = "update/update.updateUser"
  s3_bucket = aws_s3_bucket.lambdabucket01.id
  s3_key = aws_s3_object.update_lambda_zip.key
  source_code_hash = filebase64sha256("module/code/zip/update.zip")
}