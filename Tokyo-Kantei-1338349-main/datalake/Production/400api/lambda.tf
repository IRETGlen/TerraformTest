data "aws_cloudformation_stack" "lambda_stack1" {
  name = var.lambda_stack1
}

data "aws_cloudformation_stack" "lambda_stack2" {
  name = var.lambda_stack2
}

data "aws_lambda_function" "msatei" {
  function_name = data.aws_cloudformation_stack.lambda_stack1.outputs.function1name
}
data "aws_lambda_function" "msatei-prod" {
    depends_on = [
    aws_lambda_alias.msatei_prod
  ]
  function_name = data.aws_cloudformation_stack.lambda_stack1.outputs.function1name
  qualifier = "prod"
}

data "aws_lambda_function" "tsatei" {
  function_name = data.aws_cloudformation_stack.lambda_stack2.outputs.function1name
}
data "aws_lambda_function" "tsatei-prod" {
    depends_on = [
    aws_lambda_alias.tsatei_prod
  ]
  function_name = data.aws_cloudformation_stack.lambda_stack2.outputs.function1name
  qualifier = "prod"
}


# msatei alias configuration

resource "aws_lambda_alias" "msatei_test" {
  name             = "test"
  description      = "Test Resource - Always at $LATEST"
  function_name    = data.aws_lambda_function.msatei.arn
  function_version = "$LATEST"
}

resource "aws_lambda_alias" "msatei_dev" {
  name             = "dev"
  description      = "Development: current state"
  function_name    = data.aws_lambda_function.msatei.arn
  function_version = "$LATEST"
}

resource "aws_lambda_alias" "msatei_ver" {
  name             = "ver"
  description      = "Verification: current state"
  function_name    = data.aws_lambda_function.msatei.arn
  function_version = "$LATEST"
}

resource "aws_lambda_alias" "msatei_prod" {
  name             = "prod"
  description      = "Production workload"
  function_name    = data.aws_lambda_function.msatei.arn
  function_version = "$LATEST"
}

# tsatei alias configuration

resource "aws_lambda_alias" "tsatei_test" {
  name             = "test"
  description      = "Test Resource - Always at $LATEST"
  function_name    = data.aws_lambda_function.tsatei.arn
  function_version = "$LATEST"
}

resource "aws_lambda_alias" "tsatei_dev" {
  name             = "dev"
  description      = "Development: current state"
  function_name    = data.aws_lambda_function.tsatei.arn
  function_version = "$LATEST"
}

resource "aws_lambda_alias" "tsatei_ver" {
  name             = "ver"
  description      = "Verification: current state"
  function_name    = data.aws_lambda_function.tsatei.arn
  function_version = "$LATEST"
}

resource "aws_lambda_alias" "tsatei_prod" {
  name             = "prod"
  description      = "Production workload"
  function_name    = data.aws_lambda_function.tsatei.arn
  function_version = "$LATEST"
}

# Enable Execution from API Gateway:

## msatei

resource "aws_lambda_permission" "msatei_allow_apigw_test" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.msatei.id
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*"
  qualifier     = aws_lambda_alias.msatei_test.name
}

resource "aws_lambda_permission" "msatei_allow_apigw_dev" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.msatei.id
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*"
  qualifier     = aws_lambda_alias.msatei_dev.name
}

resource "aws_lambda_permission" "msatei_allow_apigw_ver" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.msatei.id
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*"
  qualifier     = aws_lambda_alias.msatei_ver.name
}

resource "aws_lambda_permission" "msatei_allow_apigw_prod" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.msatei.id
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*"
  qualifier     = aws_lambda_alias.msatei_prod.name
}

## tsatei

resource "aws_lambda_permission" "tsatei_allow_apigw_test" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.tsatei.id
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*"
  qualifier     = aws_lambda_alias.tsatei_test.name
}

resource "aws_lambda_permission" "tsatei_allow_apigw_dev" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.tsatei.id
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*"
  qualifier     = aws_lambda_alias.tsatei_dev.name
}

resource "aws_lambda_permission" "tsatei_allow_apigw_ver" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.tsatei.id
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*"
  qualifier     = aws_lambda_alias.tsatei_ver.name
}

resource "aws_lambda_permission" "tsatei_allow_apigw_prod" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.tsatei.id
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*"
  qualifier     = aws_lambda_alias.tsatei_prod.name
}
