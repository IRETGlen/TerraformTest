# Template builds and deploys a multi-tiered API Gateway for use with lambda backend.
# Requires lambda APIs available to provision and exercise required executions.

resource "aws_api_gateway_rest_api" "api" {
  name              = var.api_gateway_name
  description       = var.api_description
  api_key_source = "HEADER"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_rest_api_policy" "accesspolicy" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  policy      = data.aws_iam_policy_document.apipolicy.json
}


data "aws_iam_policy_document" "apipolicy" {
  statement {
    sid = "restrict-test"
    effect = "Deny"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = ["execute-api:Invoke"]
    resources = [
      "${aws_api_gateway_rest_api.api.execution_arn}/test/*/*"
    ]
    condition {
      test     = "NotIpAddress"
      variable = "aws:SourceIp"
      values   = [
        "140.227.46.69/32",
        "203.180.246.183/32",
        "203.180.246.184/32",
        "78.136.22.232/32"
      ]
    }
  }
  statement {
    sid = "restrict-dev"
    effect = "Deny"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = ["execute-api:Invoke"]
    resources = ["${aws_api_gateway_rest_api.api.execution_arn}/dev/*/*"]
    condition {
      test     = "NotIpAddress"
      variable = "aws:SourceIp"
      values   = [
        "140.227.46.69/32",
        "203.180.246.183/32",
        "203.180.246.184/32",
        "101.110.43.202/32",
        "101.110.43.204/32",
        "126.249.33.30/32",
        "78.136.22.232/32"
      ]
    }
  }
  statement {
    sid = "restrict-verify"
    effect = "Deny"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = ["execute-api:Invoke"]
    resources = ["${aws_api_gateway_rest_api.api.execution_arn}/ver/*/*"]
    condition {
      test     = "NotIpAddress"
      variable = "aws:SourceIp"
      values   = [
        "140.227.46.69/32",
        "203.180.246.183/32",
        "203.180.246.184/32",
        "78.136.22.232/32"
      ]
    }
  }
  statement {
    sid = "enable-prod"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = ["execute-api:Invoke"]
    resources = ["${aws_api_gateway_rest_api.api.execution_arn}/*"]
  }
}


## Land Predict Rest Methods definition:

resource "aws_api_gateway_resource" "land-predict-proxy" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  parent_id   = "${aws_api_gateway_rest_api.api.root_resource_id}"
  path_part   = "land-predict"
}

resource "aws_api_gateway_method" "land-predict-get" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  resource_id   = "${aws_api_gateway_resource.land-predict-proxy.id}"
  http_method   = "GET"
  authorization = "NONE"
  api_key_required = false
  request_parameters = {}
}

resource "aws_api_gateway_method_response" "land-predict-get_200" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.land-predict-proxy.id
  http_method = aws_api_gateway_method.land-predict-get.http_method
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  response_models = {
    "application/json" = "Empty"
  }
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "land-predict-get" {
   rest_api_id = aws_api_gateway_rest_api.api.id
   resource_id = aws_api_gateway_method.land-predict-get.resource_id
   http_method = aws_api_gateway_method.land-predict-get.http_method
   status_code = "${aws_api_gateway_method_response.land-predict-get_200.status_code}"

   response_templates = {
       "application/json" = ""
   } 
}

resource "aws_api_gateway_method_response" "land-predict-get_400" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.land-predict-proxy.id
  http_method = aws_api_gateway_method.land-predict-get.http_method
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  response_models = {
    "application/json" = "Empty"
  }
  status_code = "400"
}

resource "aws_api_gateway_method_response" "land-predict-get_403" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.land-predict-proxy.id
  http_method = aws_api_gateway_method.land-predict-get.http_method
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  response_models = {
    "application/json" = "Empty"
  }
  status_code = "403"
}

resource "aws_api_gateway_method_response" "land-predict-get_500" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.land-predict-proxy.id
  http_method = aws_api_gateway_method.land-predict-get.http_method
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  response_models = {
    "application/json" = "Empty"
  }
  status_code = "500"
}

resource "aws_api_gateway_integration" "land-predict-get" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_method.land-predict-get.resource_id
  http_method = aws_api_gateway_method.land-predict-get.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = replace("${data.aws_lambda_function.tsatei-prod.invoke_arn}", ":prod", ":$${stageVariables.alias}")
}

resource "aws_api_gateway_method" "land-predict-post" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  resource_id   = "${aws_api_gateway_resource.land-predict-proxy.id}"
  http_method   = "POST"
  authorization = "NONE"
  api_key_required = false
  request_parameters = {}
}

resource "aws_api_gateway_method_response" "land-predict-post_200" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.land-predict-proxy.id
  http_method = aws_api_gateway_method.land-predict-post.http_method
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  response_models = {
    "application/json" = "Empty"
  }
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "land-predict-post" {
   rest_api_id = aws_api_gateway_rest_api.api.id
   resource_id = aws_api_gateway_method.land-predict-post.resource_id
   http_method = aws_api_gateway_method.land-predict-post.http_method
   status_code = "${aws_api_gateway_method_response.land-predict-post_200.status_code}"

   response_templates = {
       "application/json" = ""
   } 
}

resource "aws_api_gateway_method_response" "land-predict-post_400" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.land-predict-proxy.id
  http_method = aws_api_gateway_method.land-predict-post.http_method
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  response_models = {
    "application/json" = "Empty"
  }
  status_code = "400"
}

resource "aws_api_gateway_method_response" "land-predict-post_403" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.land-predict-proxy.id
  http_method = aws_api_gateway_method.land-predict-post.http_method
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  response_models = {
    "application/json" = "Empty"
  }
  status_code = "403"
}

resource "aws_api_gateway_method_response" "land-predict-post_500" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.land-predict-proxy.id
  http_method = aws_api_gateway_method.land-predict-post.http_method
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  response_models = {
    "application/json" = "Empty"
  }
  status_code = "500"
}


resource "aws_api_gateway_integration" "land-predict-post" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_method.land-predict-post.resource_id}"
  http_method = "${aws_api_gateway_method.land-predict-post.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = replace("${data.aws_lambda_function.tsatei-prod.invoke_arn}", ":prod", ":$${stageVariables.alias}")
}

resource "aws_api_gateway_method" "land-predict-options" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  resource_id   = "${aws_api_gateway_resource.land-predict-proxy.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"
  api_key_required = false
  request_parameters = {}
}

resource "aws_api_gateway_method_response" "land-predict-options_200" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.land-predict-proxy.id
  http_method = aws_api_gateway_method.land-predict-options.http_method
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Headers"  = true
    "method.response.header.Access-Control-Allow-Methods"  = true
  }
  response_models = {
    "application/json" = "Empty"
  }
  status_code = "200"
}

resource "aws_api_gateway_method_response" "land-predict-options_400" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.land-predict-proxy.id
  http_method = aws_api_gateway_method.land-predict-options.http_method
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  response_models = {
    "application/json" = "Empty"
  }
  status_code = "400"
}

resource "aws_api_gateway_method_response" "land-predict-options_403" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.land-predict-proxy.id
  http_method = aws_api_gateway_method.land-predict-options.http_method
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  response_models = {
    "application/json" = "Empty"
  }
  status_code = "403"
}

resource "aws_api_gateway_method_response" "land-predict-options_500" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.land-predict-proxy.id
  http_method = aws_api_gateway_method.land-predict-options.http_method
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  response_models = {
    "application/json" = "Empty"
  }
  status_code = "500"
}

resource "aws_api_gateway_integration" "land-predict-options" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_method.land-predict-options.resource_id}"
  http_method = "${aws_api_gateway_method.land-predict-options.http_method}"
  type                    = "MOCK"
}

resource "aws_api_gateway_integration_response" "land-predict-options" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.land-predict-proxy.id
  http_method = aws_api_gateway_method.land-predict-options.http_method
  status_code = aws_api_gateway_method_response.land-predict-options_200.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"  = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods"  = "'GET,OPTIONS,POST'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
  # Transforms the backend JSON response to XML
  response_templates = {
    "application/xml" = <<EOF
#set($inputRoot = $input.path('$'))
<?xml version="1.0" encoding="UTF-8"?>
<message>
    $inputRoot.body
</message>
EOF
  }
}


## Mansion Predict Rest methods definition:

resource "aws_api_gateway_resource" "mansion-predict-proxy" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  parent_id   = "${aws_api_gateway_rest_api.api.root_resource_id}"
  path_part   = "mansion-predict"
}

resource "aws_api_gateway_method" "mansion-predict-get" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  resource_id   = "${aws_api_gateway_resource.mansion-predict-proxy.id}"
  http_method   = "GET"
  authorization = "NONE"
  api_key_required = false
  request_parameters = {}
}

resource "aws_api_gateway_method_response" "mansion-predict-get_200" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.mansion-predict-proxy.id
  http_method = aws_api_gateway_method.mansion-predict-get.http_method
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  response_models = {
    "application/json" = "Empty"
  }
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "mansion-predict-get" {
   rest_api_id = aws_api_gateway_rest_api.api.id
   resource_id = aws_api_gateway_resource.mansion-predict-proxy.id
   http_method = aws_api_gateway_method.mansion-predict-get.http_method
   status_code = "${aws_api_gateway_method_response.mansion-predict-get_200.status_code}"

   response_templates = {
       "application/json" = ""
   } 
}

resource "aws_api_gateway_method_response" "mansion-predict-get_400" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.mansion-predict-proxy.id
  http_method = aws_api_gateway_method.mansion-predict-get.http_method
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  response_models = {
    "application/json" = "Empty"
  }
  status_code = "400"
}

resource "aws_api_gateway_method_response" "mansion-predict-get_403" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.mansion-predict-proxy.id
  http_method = aws_api_gateway_method.mansion-predict-get.http_method
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  response_models = {
    "application/json" = "Empty"
  }
  status_code = "403"
}

resource "aws_api_gateway_method_response" "mansion-predict-get_500" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.mansion-predict-proxy.id
  http_method = aws_api_gateway_method.mansion-predict-get.http_method
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  response_models = {
    "application/json" = "Empty"
  }
  status_code = "500"
}

resource "aws_api_gateway_integration" "mansion-predict-get" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_method.mansion-predict-get.resource_id}"
  http_method = "${aws_api_gateway_method.mansion-predict-get.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = replace("${data.aws_lambda_function.msatei-prod.invoke_arn}", ":prod", ":$${stageVariables.alias}")
}

resource "aws_api_gateway_method" "mansion-predict-post" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  resource_id   = "${aws_api_gateway_resource.mansion-predict-proxy.id}"
  http_method   = "POST"
  authorization = "NONE"
  api_key_required = false
  request_parameters = {}
}

resource "aws_api_gateway_method_response" "mansion-predict-post_200" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.mansion-predict-proxy.id
  http_method = aws_api_gateway_method.mansion-predict-post.http_method
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  response_models = {
    "application/json" = "Empty"
  }
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "mansion-predict-post" {
   rest_api_id = aws_api_gateway_rest_api.api.id
   resource_id = aws_api_gateway_resource.mansion-predict-proxy.id
   http_method = aws_api_gateway_method.mansion-predict-post.http_method
   status_code = "${aws_api_gateway_method_response.mansion-predict-post_200.status_code}"

   response_templates = {
       "application/json" = ""
   } 
}

resource "aws_api_gateway_method_response" "mansion-predict-post_400" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.mansion-predict-proxy.id
  http_method = aws_api_gateway_method.mansion-predict-post.http_method
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  response_models = {
    "application/json" = "Empty"
  }
  status_code = "400"
}

resource "aws_api_gateway_method_response" "mansion-predict-post_403" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.mansion-predict-proxy.id
  http_method = aws_api_gateway_method.mansion-predict-post.http_method
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  response_models = {
    "application/json" = "Empty"
  }
  status_code = "403"
}

resource "aws_api_gateway_method_response" "mansion-predict-post_500" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.mansion-predict-proxy.id
  http_method = aws_api_gateway_method.mansion-predict-post.http_method
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  response_models = {
    "application/json" = "Empty"
  }
  status_code = "500"
}

resource "aws_api_gateway_integration" "mansion-predict-post" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_method.mansion-predict-post.resource_id}"
  http_method = "${aws_api_gateway_method.mansion-predict-post.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = replace("${data.aws_lambda_function.msatei-prod.invoke_arn}", ":prod", ":$${stageVariables.alias}")
}

resource "aws_api_gateway_method" "mansion-predict-options" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  resource_id   = "${aws_api_gateway_resource.mansion-predict-proxy.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"
  api_key_required = false
  request_parameters = {}
}

resource "aws_api_gateway_method_response" "mansion-predict-options_200" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.mansion-predict-proxy.id
  http_method = aws_api_gateway_method.mansion-predict-options.http_method
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"  = true
    "method.response.header.Access-Control-Allow-Methods"  = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  response_models = {
    "application/json" = "Empty"
  }
  status_code = "200"
}

resource "aws_api_gateway_method_response" "mansion-predict-options_400" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.mansion-predict-proxy.id
  http_method = aws_api_gateway_method.mansion-predict-options.http_method
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  response_models = {
    "application/json" = "Empty"
  }
  status_code = "400"
}

resource "aws_api_gateway_method_response" "mansion-predict-options_403" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.mansion-predict-proxy.id
  http_method = aws_api_gateway_method.mansion-predict-options.http_method
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  response_models = {
    "application/json" = "Empty"
  }
  status_code = "403"
}

resource "aws_api_gateway_method_response" "mansion-predict-options_500" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.mansion-predict-proxy.id
  http_method = aws_api_gateway_method.mansion-predict-options.http_method
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  response_models = {
    "application/json" = "Empty"
  }
  status_code = "500"
}



resource "aws_api_gateway_integration" "mansion-predict-options" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_method.mansion-predict-options.resource_id}"
  http_method = "${aws_api_gateway_method.mansion-predict-options.http_method}"
  type                    = "MOCK"
}

resource "aws_api_gateway_integration_response" "mansion-predict-options" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.mansion-predict-proxy.id
  http_method = aws_api_gateway_method.mansion-predict-options.http_method
  status_code = aws_api_gateway_method_response.mansion-predict-options_200.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"  = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods"  = "'GET,OPTIONS,POST'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
  # Transforms the backend JSON response to XML
  response_templates = {
    "application/xml" = <<EOF
#set($inputRoot = $input.path('$'))
<?xml version="1.0" encoding="UTF-8"?>
<message>
    $inputRoot.body
</message>
EOF
  }
}


## Deployment & Stage definitions:

## CW Configuration

resource "aws_api_gateway_account" "cw_api_role" {
  cloudwatch_role_arn = aws_iam_role.cw_api_role.arn
}

resource "aws_iam_role" "cw_api_role" {
  name = "Cloudwatch_role_for_APIGateway_${aws_api_gateway_rest_api.api.name}"
  assume_role_policy = data.aws_iam_policy_document.cw_api_assume_role.json
}

resource "aws_iam_role_policy_attachment" "event_bus_invoke_remote_event_bus" {
  role       = aws_iam_role.cw_api_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

data "aws_iam_policy_document" "cw_api_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_cloudwatch_log_group" "api" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.api.id}"
  retention_in_days = 7
}

## / CW Configuration

resource "aws_api_gateway_stage" "prod" {
  depends_on = [
    aws_api_gateway_account.cw_api_role,
    aws_cloudwatch_log_group.api
  ]
  rest_api_id = aws_api_gateway_rest_api.api.id
  deployment_id = aws_api_gateway_deployment.api.id
  description = "本番環境"
  stage_name = "prod"
  variables = {
    alias = "prod"
  }
  xray_tracing_enabled = false
  tags = {
    Name = "本番環境"
  }
}

resource "aws_api_gateway_method_settings" "prod" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = aws_api_gateway_stage.prod.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}

resource "aws_api_gateway_stage" "test" {
  depends_on = [
    aws_api_gateway_account.cw_api_role,
    aws_cloudwatch_log_group.api
  ]
  rest_api_id = aws_api_gateway_rest_api.api.id
  deployment_id = aws_api_gateway_deployment.api.id
  description = "試験環境"
  stage_name = "test"
  variables = {
    alias = "test"
  }
  xray_tracing_enabled = false
  tags = {
    Name = "試験環境"
  }
}

resource "aws_api_gateway_method_settings" "test" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = aws_api_gateway_stage.test.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}

resource "aws_api_gateway_stage" "dev" {
  depends_on = [
    aws_api_gateway_account.cw_api_role,
    aws_cloudwatch_log_group.api
  ]
  rest_api_id = aws_api_gateway_rest_api.api.id
  deployment_id = aws_api_gateway_deployment.api.id
  description = "開発環境"
  stage_name = "dev"
  variables = {
    alias = "dev"
  }
  xray_tracing_enabled = false
  tags = {
    Name = "開発環境"
  }
}

resource "aws_api_gateway_method_settings" "dev" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = aws_api_gateway_stage.dev.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}

resource "aws_api_gateway_stage" "ver" {
  depends_on = [
    aws_api_gateway_account.cw_api_role,
    aws_cloudwatch_log_group.api
  ]
  rest_api_id = aws_api_gateway_rest_api.api.id
  deployment_id = aws_api_gateway_deployment.api.id
  description = "検証環境"
  stage_name = "ver"
  variables = {
    alias = "ver"
  }
  xray_tracing_enabled = false
  tags = {
    Name = "検証環境"
  }
}

resource "aws_api_gateway_method_settings" "ver" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = aws_api_gateway_stage.ver.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}

resource "aws_api_gateway_deployment" "api" {
  depends_on = [
      aws_api_gateway_integration.mansion-predict-get,
      aws_api_gateway_integration.mansion-predict-post,
      aws_api_gateway_integration.mansion-predict-options,
      aws_api_gateway_integration.land-predict-get,
      aws_api_gateway_integration.land-predict-post,
      aws_api_gateway_integration.land-predict-options
  ]
  rest_api_id = aws_api_gateway_rest_api.api.id
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.mansion-predict-proxy.id,
      aws_api_gateway_resource.land-predict-proxy.id,
      aws_api_gateway_method.mansion-predict-get.id,
      aws_api_gateway_method.mansion-predict-post.id,
      aws_api_gateway_method.mansion-predict-options.id,
      aws_api_gateway_method.land-predict-get.id,
      aws_api_gateway_method.land-predict-post.id,
      aws_api_gateway_method.land-predict-options.id,
      aws_api_gateway_integration.mansion-predict-get.id,
      aws_api_gateway_integration.mansion-predict-post.id,
      aws_api_gateway_integration.mansion-predict-options.id,
      aws_api_gateway_integration.land-predict-get.id,
      aws_api_gateway_integration.land-predict-post.id,
      aws_api_gateway_integration.land-predict-options.id
    ]))
  }
  lifecycle {
    create_before_destroy = true
  }
}
