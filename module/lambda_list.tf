resource "aws_api_gateway_method" "list_user" {
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.list-user.id
  rest_api_id   = aws_api_gateway_rest_api.iac_api.id
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "list_user_lambda" {
  integration_http_method = "POST"
  http_method = aws_api_gateway_method.list_user.http_method
  resource_id = aws_api_gateway_resource.list-user.id
  rest_api_id = aws_api_gateway_rest_api.iac_api.id
  type        = "AWS_PROXY"
  uri = aws_lambda_function.list_user.invoke_arn
}

resource "aws_s3_object" "list_lambda_zip" {
  bucket = aws_s3_bucket.lambdabucket01.id
  key    = "lambdas/list.zip"
  source    = "module/code/zip/list.zip"
  etag = filemd5("module/code/zip/list.zip")
}

resource "aws_lambda_function" "list_user" {
  function_name = "users"
  role          = aws_iam_role.DatabaseRole.arn
  runtime = "nodejs22.x"
  handler = "list/list.getUsers"
  s3_bucket = aws_s3_bucket.lambdabucket01.id
  s3_key = aws_s3_object.list_lambda_zip.key
  source_code_hash = filebase64sha256("module/code/zip/list.zip")
}