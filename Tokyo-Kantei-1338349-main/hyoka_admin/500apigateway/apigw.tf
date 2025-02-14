# --------------------------------------------------------------------------------------
# --- LINK API
#    --- Resources 
#    --- Methods
#    --- Deployment
#    --- Stages
#
# --- SYSTEM API
# --------------------------------------------------------------------------------------

# -----------------------------------------------
# LINK API
# -----------------------------------------------
resource "aws_api_gateway_rest_api" "link_api" {
  name        = "LINK API"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# --------------------------------------------------------------------------------------
# Resource - getcsvdownloadlink
# Method - getcsvdownloadlink
# Method Response
# --------------------------------------------------------------------------------------

# -----------------------------------------------
# Resource - getcsvdownloadlink
# -----------------------------------------------
resource "aws_api_gateway_resource" "link_api_resource" {
  rest_api_id = aws_api_gateway_rest_api.link_api.id
  parent_id   = aws_api_gateway_rest_api.link_api.root_resource_id
  path_part   = "getcsvdownloadlink"
}

# -----------------------------------------------
# Method - getcsvdownloadlink
# -----------------------------------------------
resource "aws_api_gateway_method" "getcsvdownloadlink" {
  rest_api_id   = aws_api_gateway_rest_api.link_api.id
  resource_id   = aws_api_gateway_resource.link_api_resource.id
  http_method   = "GET"
  authorization = "NONE"
  api_key_required = true
  request_parameters = {
    "method.request.querystring.key": false
  } 
}

# -----------------------------------------------
# -----------------------------------------------
# Integration Request
# -----------------------------------------------
resource "aws_api_gateway_integration" "getcsvdownloadlink-get" {
  rest_api_id             = aws_api_gateway_rest_api.link_api.id
  resource_id             = aws_api_gateway_resource.link_api_resource.id
  http_method             = aws_api_gateway_method.getcsvdownloadlink.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:ap-northeast-1:lambda:path/2015-03-31/functions/arn:aws:lambda:ap-northeast-1:505982390831:function:GetCSVURL/invocations"
  credentials             = "arn:aws:iam::505982390831:role/shusys-API-Lambda-role"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
  request_templates = {
    "application/json": "{\r\n  \"key\": \"$input.params('key')\"\r\n}"
  }
}

# -----------------------------------------------
# Integration Response
# -----------------------------------------------
resource "aws_api_gateway_integration_response" "getcsvdownloadlink" {
  rest_api_id = aws_api_gateway_rest_api.link_api.id
  resource_id = aws_api_gateway_resource.link_api_resource.id
  http_method = aws_api_gateway_method.getcsvdownloadlink.http_method
  status_code = aws_api_gateway_method_response.getcsvdownloadlink-get_200.status_code
}
# -----------------------------------------------
# -----------------------------------------------

# -----------------------------------------------
# Method Response
# -----------------------------------------------
resource "aws_api_gateway_method_response" "getcsvdownloadlink-get_200" {
  rest_api_id = aws_api_gateway_rest_api.link_api.id
  resource_id = aws_api_gateway_resource.link_api_resource.id
  http_method = aws_api_gateway_method.getcsvdownloadlink.http_method
  status_code = "200"
  response_models = {
    "application/json": "Empty"
  }  
}


# --------------------------------------------------------------------------------------
# Resource - start-stepfunction
# - Method - start-stepfunction
# - Integration Request 
# - Integration Response
# - Method Response
# --------------------------------------------------------------------------------------

# -----------------------------------------------
# Resource - start-stepfunction
# -----------------------------------------------
resource "aws_api_gateway_resource" "link_api_start-stepfunction" {
  rest_api_id = aws_api_gateway_rest_api.link_api.id
  parent_id   = aws_api_gateway_rest_api.link_api.root_resource_id
  path_part   = "start-stepfunction"
}

# -----------------------------------------------
# Method - start-stepfunction
# -----------------------------------------------
resource "aws_api_gateway_method" "start-stepfunction" {
  rest_api_id      = aws_api_gateway_rest_api.link_api.id
  resource_id      = aws_api_gateway_resource.link_api_start-stepfunction.id
  http_method      = "POST"
  authorization    = "NONE"
  api_key_required = true
}

# -----------------------------------------------
# Integration Request
# -----------------------------------------------
resource "aws_api_gateway_integration" "start-stepfunction-post" {
  rest_api_id             = aws_api_gateway_rest_api.link_api.id
  resource_id             = aws_api_gateway_resource.link_api_start-stepfunction.id
  http_method             = aws_api_gateway_method.start-stepfunction.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:ap-northeast-1:states:action/StartExecution"
  credentials             = "arn:aws:iam::505982390831:role/API-StepFunctions-role"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
  request_templates = {
    "application/json" = "#set( $body = $util.escapeJavaScript($input.json('$')) )\r\n{\r\n    \"input\": \"$body\",\r\n    \"stateMachineArn\": \"arn:aws:states:ap-northeast-1:505982390831:stateMachine:CreateCSV\"\r\n}"
  }
}

# -----------------------------------------------
# Integration Response
# -----------------------------------------------
resource "aws_api_gateway_integration_response" "start-stepfunction" {
  rest_api_id = aws_api_gateway_rest_api.link_api.id
  resource_id = aws_api_gateway_resource.link_api_start-stepfunction.id
  http_method = aws_api_gateway_method.start-stepfunction.http_method
  status_code = aws_api_gateway_method_response.start-stepfunction-post_response200.status_code
}

# -----------------------------------------------
# Method Response
# -----------------------------------------------
resource "aws_api_gateway_method_response" "start-stepfunction-post_response200" {
  rest_api_id = aws_api_gateway_rest_api.link_api.id
  resource_id = aws_api_gateway_resource.link_api_start-stepfunction.id
  http_method = aws_api_gateway_method.start-stepfunction.http_method
  status_code = "200"
  response_models = {
    "application/json": "Empty"
  }
}


# --------------------------------------------------------------------------------------
# Resource - getstautas
# - Method - getstautas
# - Integration Request 
# - Integration Response
# - Method Response
# --------------------------------------------------------------------------------------

# -----------------------------------------------
# Resource - getstautas
# -----------------------------------------------
resource "aws_api_gateway_resource" "link_api_getstautas" {
  rest_api_id = aws_api_gateway_rest_api.link_api.id
  parent_id   = aws_api_gateway_resource.link_api_start-stepfunction.id
  path_part   = "getstautas"
}


# -----------------------------------------------
# Method - getstautas
# -----------------------------------------------
resource "aws_api_gateway_method" "getstautas" {
  rest_api_id      = aws_api_gateway_rest_api.link_api.id
  resource_id      = aws_api_gateway_resource.link_api_getstautas.id
  http_method      = "POST"
  authorization    = "NONE"
  api_key_required = false
}

# -----------------------------------------------
# Integration Request
# -----------------------------------------------
resource "aws_api_gateway_integration" "getstautas-post" {
  rest_api_id             = aws_api_gateway_rest_api.link_api.id
  resource_id             = aws_api_gateway_resource.link_api_getstautas.id
  http_method             = aws_api_gateway_method.getstautas.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:ap-northeast-1:states:action/DescribeExecution"
  credentials             = "arn:aws:iam::505982390831:role/API-StepFunctions-role"
  passthrough_behavior    = "WHEN_NO_MATCH"
}

# -----------------------------------------------
# Integration Response
# -----------------------------------------------
resource "aws_api_gateway_integration_response" "getstautas" {
  rest_api_id = aws_api_gateway_rest_api.link_api.id
  resource_id = aws_api_gateway_resource.link_api_getstautas.id
  http_method = aws_api_gateway_method.getstautas.http_method
  status_code = aws_api_gateway_method_response.getstautas-post_response200.status_code

  # Transforms the backend JSON response to XML
  response_templates = {
    "application/json": "{\r\n    \"output\": $input.json('$.output'),\r\n    \"status\": $input.json('$.status'),\r\n    \"all\":$input.json('$')\r\n} "
  }
}


# -----------------------------------------------
# Method Response
# -----------------------------------------------
resource "aws_api_gateway_method_response" "getstautas-post_response200" {
  rest_api_id = aws_api_gateway_rest_api.link_api.id
  resource_id = aws_api_gateway_resource.link_api_getstautas.id
  http_method = aws_api_gateway_method.getstautas.http_method
  status_code = "200"
  response_models = {
    "application/json": "Empty"
  }
}


# --------------------------------------------------------------------------------------
# Resource - prospect
# - Method - prospect
# - Integration Request 
# - Integration Response
# - Method Response
# --------------------------------------------------------------------------------------

# -----------------------------------------------
# Resource - prospect
# -----------------------------------------------
resource "aws_api_gateway_resource" "link_api_prospect" {
  rest_api_id = aws_api_gateway_rest_api.link_api.id
  parent_id   = aws_api_gateway_resource.link_api_start-stepfunction.id
  path_part   = "prospect"
}


# -----------------------------------------------
# Method - prospect
# -----------------------------------------------
resource "aws_api_gateway_method" "prospect" {
  rest_api_id      = aws_api_gateway_rest_api.link_api.id
  resource_id      = aws_api_gateway_resource.link_api_prospect.id
  http_method      = "POST"
  authorization    = "NONE"
  api_key_required = true
}

# -----------------------------------------------
# Integration Request
# -----------------------------------------------
resource "aws_api_gateway_integration" "prospect-post" {
  rest_api_id             = aws_api_gateway_rest_api.link_api.id
  resource_id             = aws_api_gateway_resource.link_api_prospect.id
  http_method             = aws_api_gateway_method.prospect.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:ap-northeast-1:states:action/StartExecution"
  credentials             = "arn:aws:iam::505982390831:role/API-StepFunctions-role"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
  request_templates = {
    "application/json": "#set( $body = $util.escapeJavaScript($input.json('$')) )\r\n{\r\n    \"input\": \"$body\",\r\n    \"stateMachineArn\": \"arn:aws:states:ap-northeast-1:505982390831:stateMachine:CreateCSVProspect\"\r\n} "
  }
}

# -----------------------------------------------
# Integration Response
# -----------------------------------------------
resource "aws_api_gateway_integration_response" "prospect" {
  rest_api_id             = aws_api_gateway_rest_api.link_api.id
  resource_id             = aws_api_gateway_resource.link_api_prospect.id
  http_method             = aws_api_gateway_method.prospect.http_method
  status_code             = aws_api_gateway_method_response.prospect-post_response200.status_code
}

# -----------------------------------------------
# Method Response
# -----------------------------------------------
resource "aws_api_gateway_method_response" "prospect-post_response200" {
  rest_api_id             = aws_api_gateway_rest_api.link_api.id
  resource_id             = aws_api_gateway_resource.link_api_prospect.id
  http_method             = aws_api_gateway_method.prospect.http_method
  status_code = "200"
  response_models = {
    "application/json": "Empty"
  }
}


# -----------------------------------------------
# Deployment
# -----------------------------------------------
resource "aws_api_gateway_deployment" "linkapi_deployment" {
  rest_api_id = aws_api_gateway_rest_api.link_api.id  
  triggers = {
    redeployment = sha1(jsonencode([
    ]))
  }
  lifecycle {
    create_before_destroy = true
  }
}


# -----------------------------------------------
# Stage - prd
# -----------------------------------------------
resource "aws_api_gateway_stage" "prd" {
  rest_api_id = aws_api_gateway_rest_api.link_api.id  
  deployment_id = aws_api_gateway_deployment.linkapi_deployment.id
  description = "本番用"
  stage_name = "prd"
  xray_tracing_enabled = false
}

resource "aws_api_gateway_method_settings" "prd" {
  rest_api_id = aws_api_gateway_rest_api.link_api.id  
  stage_name  = aws_api_gateway_stage.prd.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = false
    logging_level   = "OFF"
    throttling_burst_limit = 5000
    throttling_rate_limit = 10000
  } 
}

# -----------------------------------------------
# API Keys 
# -----------------------------------------------
resource "aws_api_gateway_api_key" "systemapi_key" {
  name = "SYSTEM API-Key"
}

resource "aws_api_gateway_api_key" "linkapi_key" {
  name = "LINK API-Key"
}

# -----------------------------------------------
# Usage Plans - SYSTEM API
# -----------------------------------------------
resource "aws_api_gateway_usage_plan" "systemapi_usageplan" {
  name = "SYSTEM API-UsagePlan"

  api_stages {
    api_id = aws_api_gateway_rest_api.system_api.id  
    stage  = aws_api_gateway_stage.systemapi_prd.stage_name
  }
}

resource "aws_api_gateway_usage_plan_key" "systemapi_usageplan_key" {
  key_id        = aws_api_gateway_api_key.systemapi_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.systemapi_usageplan.id
}

# -----------------------------------------------
# Usage Plans - LINK API
# -----------------------------------------------
resource "aws_api_gateway_usage_plan" "linkapi_usageplan" {
  name = "LINK API-UsagePlan"

  api_stages {
    api_id = aws_api_gateway_rest_api.link_api.id  
    stage  = aws_api_gateway_stage.prd.stage_name
  }
}

resource "aws_api_gateway_usage_plan_key" "linkapi_usageplan_key" {
  key_id        = aws_api_gateway_api_key.linkapi_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.linkapi_usageplan.id
}