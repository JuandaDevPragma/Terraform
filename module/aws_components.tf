#Database configuration
resource "aws_dynamodb_table" "UsersTable" {
  name = "UsersTable"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name = "Users Terraform"
    Environment = "Dev"
  }
}

#Topic configuration for SNS
resource "aws_sns_topic" "UserSavedTopic" {
  name = "UserSavedTopic"
}

#Queue configuration for SQS
resource "aws_sqs_queue" "UsersQueue" {
  name = "UsersQueue"
}

#Gateway settings for lambdas access
#Gateway
resource "aws_api_gateway_rest_api" "iac_api" {
  name = "iac_api"
  description = "Rest Api Gateway for access to lambdas"
}

resource "aws_api_gateway_resource" "list-user" {
  rest_api_id = aws_api_gateway_rest_api.iac_api.id
  parent_id = aws_api_gateway_rest_api.iac_api.root_resource_id
  path_part = "users"
}

resource "aws_api_gateway_resource" "user-id" {
  rest_api_id = aws_api_gateway_rest_api.iac_api.id
  parent_id = aws_api_gateway_resource.list-user.id
  path_part = "{id}"
}

resource "aws_api_gateway_resource" "create-user" {
  rest_api_id = aws_api_gateway_rest_api.iac_api.id
  parent_id = aws_api_gateway_rest_api.iac_api.root_resource_id
  path_part = "create-user"
}

resource "aws_api_gateway_resource" "update-user" {
  rest_api_id = aws_api_gateway_rest_api.iac_api.id
  parent_id = aws_api_gateway_rest_api.iac_api.root_resource_id
  path_part = "update-user"
}

resource "aws_api_gateway_resource" "update-user-id" {
  rest_api_id = aws_api_gateway_rest_api.iac_api.id
  parent_id = aws_api_gateway_resource.update-user.id
  path_part = "{id}"
}

resource "aws_api_gateway_resource" "delete-user" {
  rest_api_id = aws_api_gateway_rest_api.iac_api.id
  parent_id = aws_api_gateway_rest_api.iac_api.root_resource_id
  path_part = "delete-user"
}

resource "aws_api_gateway_resource" "delete-user-id" {
  rest_api_id = aws_api_gateway_rest_api.iac_api.id
  parent_id = aws_api_gateway_resource.delete-user.id
  path_part = "{id}"
}

locals {
  lambdas = {
    list = aws_lambda_function.list_user.function_name
    get = aws_lambda_function.get_user.function_name
    create = aws_lambda_function.create_user.function_name
    update = aws_lambda_function.update_user.function_name
    delete = aws_lambda_function.delete_user.function_name
  }
}

resource "aws_lambda_permission" "api_gw_lambda" {
  for_each = local.lambdas
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = each.value
}

resource "aws_api_gateway_deployment" "deploy" {
  rest_api_id = aws_api_gateway_rest_api.iac_api.id
  depends_on = [
    aws_api_gateway_integration.create_user_lambda,
    aws_api_gateway_integration.list_user_lambda,
    aws_api_gateway_integration.get_user_lambda,
    aws_api_gateway_integration.update_user_lambda,
    aws_api_gateway_integration.delete_user_lambda
  ]
}

resource "aws_api_gateway_stage" "deployment" {
  deployment_id = aws_api_gateway_deployment.deploy.id
  rest_api_id   = aws_api_gateway_rest_api.iac_api.id
  stage_name    = "dev"
}

resource "aws_s3_bucket" "lambdabucket01" {
  bucket = "lambda-bucket-api-01"
}

output "api_gateway_url" {
  value = "https://${aws_api_gateway_rest_api.iac_api.id}.execute-api.us-east-2.amazonaws.com/${aws_api_gateway_stage.deployment.stage_name}"
  depends_on = [
    aws_api_gateway_rest_api.iac_api,
    aws_api_gateway_stage.deployment
  ]
}

resource "aws_s3_bucket_public_access_block" "lambda_bucket_conf" {
  bucket = aws_s3_bucket.lambdabucket01.id

  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}