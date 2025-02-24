resource "aws_api_gateway_method" "create_user" {
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.create-user.id
  rest_api_id   = aws_api_gateway_rest_api.iac_api.id
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "create_user_lambda" {
  integration_http_method = "POST"
  http_method = aws_api_gateway_method.create_user.http_method
  resource_id = aws_api_gateway_resource.create-user.id
  rest_api_id = aws_api_gateway_rest_api.iac_api.id
  type        = "AWS_PROXY"
  uri = aws_lambda_function.create_user.invoke_arn
}

resource "aws_s3_object" "create_lambda_zip" {
  bucket = aws_s3_bucket.lambdabucket01.id
  key    = "lambdas/create.zip"
  source    = "module/code/zip/create.zip"
  etag = filemd5("module/code/zip/create.zip")
}

resource "aws_lambda_function" "create_user" {
  function_name = "create"
  role          = aws_iam_role.CreateUserRole.arn
  runtime = "nodejs22.x"
  handler = "create/create.createUser"
  s3_bucket = aws_s3_bucket.lambdabucket01.id
  s3_key = aws_s3_object.create_lambda_zip.key
  source_code_hash = filebase64sha256("module/code/zip/create.zip")
}