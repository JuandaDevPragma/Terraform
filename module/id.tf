resource "aws_api_gateway_method" "get_user" {
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.user-id.id
  rest_api_id   = aws_api_gateway_rest_api.iac_api.id
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_user_lambda" {
  integration_http_method = "POST"
  http_method = aws_api_gateway_method.get_user.http_method
  resource_id = aws_api_gateway_resource.user-id.id
  rest_api_id = aws_api_gateway_rest_api.iac_api.id
  type        = "AWS_PROXY"
  uri = aws_lambda_function.get_user.invoke_arn
}

resource "aws_s3_object" "get_lambda_zip" {
  bucket = aws_s3_bucket.lambdabucket01.id
  key    = "lambdas/id.zip"
  source    = "module/code/zip/id.zip"
  etag = filemd5("module/code/zip/id.zip")
}

resource "aws_lambda_function" "get_user" {
  function_name = "user"
  role          = aws_iam_role.DatabaseRole.arn
  runtime = "nodejs22.x"
  handler = "id/id.getUser"
  s3_bucket = aws_s3_bucket.lambdabucket01.id
  s3_key = aws_s3_object.get_lambda_zip.key
  source_code_hash = filebase64sha256("module/code/zip/id.zip")
}