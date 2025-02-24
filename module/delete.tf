resource "aws_api_gateway_method" "delete_user" {
  http_method   = "DELETE"
  resource_id   = aws_api_gateway_resource.delete-user-id.id
  rest_api_id   = aws_api_gateway_rest_api.iac_api.id
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "delete_user_lambda" {
  integration_http_method = "POST"
  http_method = aws_api_gateway_method.delete_user.http_method
  resource_id = aws_api_gateway_resource.delete-user-id.id
  rest_api_id = aws_api_gateway_rest_api.iac_api.id
  type        = "AWS_PROXY"
  uri = aws_lambda_function.delete_user.invoke_arn
}

resource "aws_s3_object" "delete_lambda_zip" {
  bucket = aws_s3_bucket.lambdabucket01.id
  key    = "lambdas/delete.zip"
  source    = "module/code/zip/delete.zip"
  etag = filemd5("module/code/zip/delete.zip")
}

resource "aws_lambda_function" "delete_user" {
  function_name = "delete"
  role          = aws_iam_role.DatabaseRole.arn
  runtime = "nodejs22.x"
  handler = "delete/delete.deleteUser"
  s3_bucket = aws_s3_bucket.lambdabucket01.id
  s3_key = aws_s3_object.delete_lambda_zip.key
  source_code_hash = filebase64sha256("module/code/zip/delete.zip")
}