###############################################################
# --- SYSTEM API
#    --- Authorizer
#    --- Resources 
#    --- Methods
#    --- Deployment
#    --- Stages
###############################################################

# -----------------------------------------------
# SYSTEM API
# -----------------------------------------------
resource "aws_api_gateway_rest_api" "system_api" {
  name        = "SYSTEM API"
  endpoint_configuration {
    types = ["PRIVATE"]
  }
}

# -----------------------------------------------
# Authorizer
# -----------------------------------------------
resource "aws_api_gateway_authorizer" "systemapi_authorizer" {
  name                   = "HyokaAuthorizer"
  type                   = "COGNITO_USER_POOLS"
  rest_api_id            = aws_api_gateway_rest_api.system_api.id
#   provider_arns          = [var.cognito_userpool_arn]
  provider_arns          = [aws_cognito_user_pool.hyoka_userpool.arn]
}


##
# -----------------------------------------------
# Resource Policy
# -----------------------------------------------
data "aws_iam_policy_document" "apigw_resource_policy1" {
  statement {
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions   = ["execute-api:Invoke"]
    resources = ["execute-api:/*"]
  }
}

data "aws_iam_policy_document" "apigw_resource_policy2" {
  statement {
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions   = ["execute-api:Invoke"]
    resources = ["execute-api:/*"]

    condition {
      test     = "StringNotEquals"
      variable = "aws:SourceVpce"
      # values   = ["vpce-020a9854bd144315a"]
      values   = [data.terraform_remote_state.base_network.outputs.hyoka_apigw_vpc_endpoint]
    }
  }
}

data "aws_iam_policy_document" "combined" {
  source_policy_documents = [
    data.aws_iam_policy_document.apigw_resource_policy1.json,
    data.aws_iam_policy_document.apigw_resource_policy2.json
  ]
}

resource "aws_api_gateway_rest_api_policy" "apigw_resource_policy" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  policy      = data.aws_iam_policy_document.combined.json
}
##

###############################################################
# 1. Resource - actionrenkeikeydeletebuild
###############################################################
resource "aws_api_gateway_resource" "system_api_resource" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  parent_id   = aws_api_gateway_rest_api.system_api.root_resource_id
  path_part   = "actionrenkeikeydeletebuild"
}

resource "aws_api_gateway_method" "actionrenkeikeydeletebuild" {
  rest_api_id   = aws_api_gateway_rest_api.system_api.id
  resource_id   = aws_api_gateway_resource.system_api_resource.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.systemapi_authorizer.id
  api_key_required = true
}

resource "aws_api_gateway_integration" "actionrenkeikeydeletebuild-post" {
  rest_api_id             = aws_api_gateway_rest_api.system_api.id
  resource_id             = aws_api_gateway_resource.system_api_resource.id
  http_method             = aws_api_gateway_method.actionrenkeikeydeletebuild.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:ap-northeast-1:states:action/StartExecution"
  credentials             = "arn:aws:iam::${var.aws_account_id}:role/API-StepFunctions-role"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
  request_templates = {
    "application/json": "#set( $body = $util.escapeJavaScript($input.json('$')) )\r\n{\r\n    \"input\": \"$body\",\r\n    \"stateMachineArn\": \"arn:aws:states:ap-northeast-1:${var.aws_account_id}:stateMachine:ActionRenkeiKeyDeleteBuild\"\r\n} "
  }
}

resource "aws_api_gateway_integration_response" "actionrenkeikeydeletebuild" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  resource_id = aws_api_gateway_resource.system_api_resource.id
  http_method = aws_api_gateway_method.actionrenkeikeydeletebuild.http_method
  status_code = aws_api_gateway_method_response.actionrenkeikeydeletebuild-post_200.status_code
}

resource "aws_api_gateway_method_response" "actionrenkeikeydeletebuild-post_200" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  resource_id = aws_api_gateway_resource.system_api_resource.id
  http_method = aws_api_gateway_method.actionrenkeikeydeletebuild.http_method
  status_code = "200"
  response_models = {
    "application/json": "Empty"
  }  
}


###############################################################
# 2. Resource - actionrenkeikeyeditfreekey
###############################################################
resource "aws_api_gateway_resource" "actionrenkeikeyeditfreekey" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  parent_id   = aws_api_gateway_rest_api.system_api.root_resource_id
  path_part   = "actionrenkeikeyeditfreekey"
}

resource "aws_api_gateway_method" "actionrenkeikeyeditfreekey" {
  rest_api_id   = aws_api_gateway_rest_api.system_api.id
  resource_id   = aws_api_gateway_resource.actionrenkeikeyeditfreekey.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.systemapi_authorizer.id
  api_key_required = true
}

resource "aws_api_gateway_integration" "actionrenkeikeyeditfreekey-post" {
  rest_api_id             = aws_api_gateway_rest_api.system_api.id
  resource_id             = aws_api_gateway_resource.actionrenkeikeyeditfreekey.id
  http_method             = aws_api_gateway_method.actionrenkeikeyeditfreekey.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:ap-northeast-1:states:action/StartExecution"
  credentials             = "arn:aws:iam::${var.aws_account_id}:role/API-StepFunctions-role"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
  request_templates = {
    "application/json": "#set( $body = $util.escapeJavaScript($input.json('$')) )\r\n{\r\n    \"input\": \"$body\",\r\n    \"stateMachineArn\": \"arn:aws:states:ap-northeast-1:931756137289:stateMachine:ActionRenkeiKeyEditFreeKey\"\r\n} "
  }
}

resource "aws_api_gateway_integration_response" "actionrenkeikeyeditfreekey" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  resource_id = aws_api_gateway_resource.actionrenkeikeyeditfreekey.id
  http_method = aws_api_gateway_method.actionrenkeikeyeditfreekey.http_method
  status_code = aws_api_gateway_method_response.actionrenkeikeyeditfreekey-post_200.status_code
}

resource "aws_api_gateway_method_response" "actionrenkeikeyeditfreekey-post_200" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  resource_id = aws_api_gateway_resource.actionrenkeikeyeditfreekey.id
  http_method = aws_api_gateway_method.actionrenkeikeyeditfreekey.http_method
  status_code = "200"
  response_models = {
    "application/json": "Empty"
  }  
}

###############################################################
# 3. Resource - actionrenkeikeyeditoptionalitem
###############################################################
resource "aws_api_gateway_resource" "actionrenkeikeyeditoptionalitem" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  parent_id   = aws_api_gateway_rest_api.system_api.root_resource_id
  path_part   = "actionrenkeikeyeditoptionalitem"
}

resource "aws_api_gateway_method" "actionrenkeikeyeditoptionalitem" {
  rest_api_id   = aws_api_gateway_rest_api.system_api.id
  resource_id   = aws_api_gateway_resource.actionrenkeikeyeditoptionalitem.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.systemapi_authorizer.id
  api_key_required = true
}

resource "aws_api_gateway_integration" "actionrenkeikeyeditoptionalitem-post" {
  rest_api_id             = aws_api_gateway_rest_api.system_api.id
  resource_id             = aws_api_gateway_resource.actionrenkeikeyeditoptionalitem.id
  http_method             = aws_api_gateway_method.actionrenkeikeyeditoptionalitem.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:ap-northeast-1:states:action/StartExecution"
  credentials             = "arn:aws:iam::${var.aws_account_id}:role/API-StepFunctions-role"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
  request_templates = {
    "application/json": "#set( $body = $util.escapeJavaScript($input.json('$')) )\r\n{\r\n    \"input\": \"$body\",\r\n    \"stateMachineArn\": \"arn:aws:states:ap-northeast-1:${var.aws_account_id}:stateMachine:ActionRenkeiKeyEditOptionalItem\"\r\n} "
  }
}

resource "aws_api_gateway_integration_response" "actionrenkeikeyeditoptionalitem" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  resource_id = aws_api_gateway_resource.actionrenkeikeyeditoptionalitem.id
  http_method = aws_api_gateway_method.actionrenkeikeyeditoptionalitem.http_method
  status_code = aws_api_gateway_method_response.actionrenkeikeyeditoptionalitem-post_200.status_code
}

resource "aws_api_gateway_method_response" "actionrenkeikeyeditoptionalitem-post_200" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  resource_id = aws_api_gateway_resource.actionrenkeikeyeditoptionalitem.id
  http_method = aws_api_gateway_method.actionrenkeikeyeditoptionalitem.http_method
  status_code = "200"
  response_models = {
    "application/json": "Empty"
  }  
}


###############################################################
# 4. Resource - actionrenkeikeyeditrenkeikey
###############################################################
resource "aws_api_gateway_resource" "actionrenkeikeyeditrenkeikey" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  parent_id   = aws_api_gateway_rest_api.system_api.root_resource_id
  path_part   = "actionrenkeikeyeditrenkeikey"
}

resource "aws_api_gateway_method" "actionrenkeikeyeditrenkeikey" {
  rest_api_id   = aws_api_gateway_rest_api.system_api.id
  resource_id   = aws_api_gateway_resource.actionrenkeikeyeditrenkeikey.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.systemapi_authorizer.id
  api_key_required = true
}

resource "aws_api_gateway_integration" "actionrenkeikeyeditrenkeikey-post" {
  rest_api_id             = aws_api_gateway_rest_api.system_api.id
  resource_id             = aws_api_gateway_resource.actionrenkeikeyeditrenkeikey.id
  http_method             = aws_api_gateway_method.actionrenkeikeyeditrenkeikey.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:ap-northeast-1:states:action/StartExecution"
  credentials             = "arn:aws:iam::${var.aws_account_id}:role/API-StepFunctions-role"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
  request_templates = {
    "application/json": "#set( $body = $util.escapeJavaScript($input.json('$')) )\r\n{\r\n    \"input\": \"$body\",\r\n    \"stateMachineArn\": \"arn:aws:states:ap-northeast-1:${var.aws_account_id}:stateMachine:ActionRenkeiKeyEditRenkeiKey\"\r\n} "
   }
}

resource "aws_api_gateway_integration_response" "actionrenkeikeyeditrenkeikey" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  resource_id = aws_api_gateway_resource.actionrenkeikeyeditrenkeikey.id
  http_method = aws_api_gateway_method.actionrenkeikeyeditrenkeikey.http_method
  status_code = aws_api_gateway_method_response.actionrenkeikeyeditrenkeikey-post_200.status_code
}

resource "aws_api_gateway_method_response" "actionrenkeikeyeditrenkeikey-post_200" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  resource_id = aws_api_gateway_resource.actionrenkeikeyeditrenkeikey.id
  http_method = aws_api_gateway_method.actionrenkeikeyeditrenkeikey.http_method
  status_code = "200"
  response_models = {
    "application/json": "Empty"
  }  
}


###############################################################
# 5. Resource - checkeditkey
###############################################################
resource "aws_api_gateway_resource" "checkeditkey" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  parent_id   = aws_api_gateway_rest_api.system_api.root_resource_id
  path_part   = "checkeditkey"
}

resource "aws_api_gateway_method" "checkeditkey" {
  rest_api_id   = aws_api_gateway_rest_api.system_api.id
  resource_id   = aws_api_gateway_resource.checkeditkey.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.systemapi_authorizer.id
  api_key_required = true
}

resource "aws_api_gateway_integration" "checkeditkey-post" {
  rest_api_id             = aws_api_gateway_rest_api.system_api.id
  resource_id             = aws_api_gateway_resource.checkeditkey.id
  http_method             = aws_api_gateway_method.checkeditkey.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:ap-northeast-1:lambda:path/2015-03-31/functions/arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:CheckEditKey/invocations"
  credentials             = "arn:aws:iam::${var.aws_account_id}:role/shusys-API-Lambda-role"
  passthrough_behavior    = "WHEN_NO_MATCH"
}

resource "aws_api_gateway_integration_response" "checkeditkey" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  resource_id = aws_api_gateway_resource.checkeditkey.id
  http_method = aws_api_gateway_method.checkeditkey.http_method
  status_code = aws_api_gateway_method_response.checkeditkey-post_200.status_code
}

resource "aws_api_gateway_method_response" "checkeditkey-post_200" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  resource_id = aws_api_gateway_resource.checkeditkey.id
  http_method = aws_api_gateway_method.checkeditkey.http_method
  status_code = "200"
  response_models = {
    "application/json": "Empty"
  }  
}


###############################################################
# 6. Resource - checkloadrenkeikey
###############################################################
resource "aws_api_gateway_resource" "checkloadrenkeikey" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  parent_id   = aws_api_gateway_rest_api.system_api.root_resource_id
  path_part   = "checkloadrenkeikey"
}

resource "aws_api_gateway_method" "checkloadrenkeikey" {
  rest_api_id   = aws_api_gateway_rest_api.system_api.id
  resource_id   = aws_api_gateway_resource.checkloadrenkeikey.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.systemapi_authorizer.id
  api_key_required = true
}

resource "aws_api_gateway_integration" "checkloadrenkeikey-post" {
  rest_api_id             = aws_api_gateway_rest_api.system_api.id
  resource_id             = aws_api_gateway_resource.checkloadrenkeikey.id
  http_method             = aws_api_gateway_method.checkloadrenkeikey.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:ap-northeast-1:states:action/StartExecution"
  credentials             = "arn:aws:iam::${var.aws_account_id}:role/API-StepFunctions-role"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
  request_templates = {
    "application/json": "#set( $body = $util.escapeJavaScript($input.json('$')) )\r\n{\r\n    \"input\": \"$body\",\r\n    \"stateMachineArn\": \"arn:aws:states:ap-northeast-1:${var.aws_account_id}:stateMachine:CheckLoadRenkeiKey\"\r\n} "
  }
}

resource "aws_api_gateway_integration_response" "checkloadrenkeikey" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  resource_id = aws_api_gateway_resource.checkloadrenkeikey.id
  http_method = aws_api_gateway_method.checkloadrenkeikey.http_method
  status_code = aws_api_gateway_method_response.checkloadrenkeikey-post_200.status_code
}

resource "aws_api_gateway_method_response" "checkloadrenkeikey-post_200" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  resource_id = aws_api_gateway_resource.checkloadrenkeikey.id
  http_method = aws_api_gateway_method.checkloadrenkeikey.http_method
  status_code = "200"
  response_models = {
    "application/json": "Empty"
  }  
}


###############################################################
# 7. Resource - createcsv
###############################################################
resource "aws_api_gateway_resource" "createcsv" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  parent_id   = aws_api_gateway_rest_api.system_api.root_resource_id
  path_part   = "createcsv"
}

resource "aws_api_gateway_method" "createcsv" {
  rest_api_id   = aws_api_gateway_rest_api.system_api.id
  resource_id   = aws_api_gateway_resource.createcsv.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.systemapi_authorizer.id
  api_key_required = true
}

resource "aws_api_gateway_integration" "createcsv-post" {
  rest_api_id             = aws_api_gateway_rest_api.system_api.id
  resource_id             = aws_api_gateway_resource.createcsv.id
  http_method             = aws_api_gateway_method.createcsv.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:ap-northeast-1:lambda:path/2015-03-31/functions/arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:CreateCsv/invocations"
  credentials             = "arn:aws:iam::${var.aws_account_id}:role/shusys-API-Lambda-role"
  passthrough_behavior    = "WHEN_NO_MATCH"
}

resource "aws_api_gateway_integration_response" "createcsv" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  resource_id = aws_api_gateway_resource.createcsv.id
  http_method = aws_api_gateway_method.createcsv.http_method
  status_code = aws_api_gateway_method_response.createcsv-post_200.status_code
}

resource "aws_api_gateway_method_response" "createcsv-post_200" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  resource_id = aws_api_gateway_resource.createcsv.id
  http_method = aws_api_gateway_method.createcsv.http_method
  status_code = "200"
  response_models = {
    "application/json": "Empty"
  }  
}


###############################################################
# 8. Resource - deletebuild
###############################################################
resource "aws_api_gateway_resource" "deletebuild" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  parent_id   = aws_api_gateway_rest_api.system_api.root_resource_id
  path_part   = "deletebuild"
}

resource "aws_api_gateway_method" "deletebuild" {
  rest_api_id   = aws_api_gateway_rest_api.system_api.id
  resource_id   = aws_api_gateway_resource.deletebuild.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.systemapi_authorizer.id
  api_key_required = true
}

resource "aws_api_gateway_integration" "deletebuild-post" {
  rest_api_id             = aws_api_gateway_rest_api.system_api.id
  resource_id             = aws_api_gateway_resource.deletebuild.id
  http_method             = aws_api_gateway_method.deletebuild.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:ap-northeast-1:lambda:path/2015-03-31/functions/arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:DeleteBuild/invocations"
  credentials             = "arn:aws:iam::${var.aws_account_id}:role/shusys-API-Lambda-role"
  passthrough_behavior    = "WHEN_NO_MATCH"
}

resource "aws_api_gateway_integration_response" "deletebuild" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  resource_id = aws_api_gateway_resource.deletebuild.id
  http_method = aws_api_gateway_method.deletebuild.http_method
  status_code = aws_api_gateway_method_response.deletebuild-post_200.status_code
}

resource "aws_api_gateway_method_response" "deletebuild-post_200" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  resource_id = aws_api_gateway_resource.deletebuild.id
  http_method = aws_api_gateway_method.deletebuild.http_method
  status_code = "200"
  response_models = {
    "application/json": "Empty"
  }  
}


###############################################################
# 9. Resource - editfreekey
###############################################################
resource "aws_api_gateway_resource" "editfreekey" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  parent_id   = aws_api_gateway_rest_api.system_api.root_resource_id
  path_part   = "editfreekey"
}

resource "aws_api_gateway_method" "editfreekey" {
  rest_api_id   = aws_api_gateway_rest_api.system_api.id
  resource_id   = aws_api_gateway_resource.editfreekey.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.systemapi_authorizer.id
  api_key_required = true
}

resource "aws_api_gateway_integration" "editfreekey-post" {
  rest_api_id             = aws_api_gateway_rest_api.system_api.id
  resource_id             = aws_api_gateway_resource.editfreekey.id
  http_method             = aws_api_gateway_method.editfreekey.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:ap-northeast-1:lambda:path/2015-03-31/functions/arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:EditFreeKey/invocations"
  credentials             = "arn:aws:iam::${var.aws_account_id}:role/shusys-API-Lambda-role"
  passthrough_behavior    = "WHEN_NO_MATCH"
}

resource "aws_api_gateway_integration_response" "editfreekey" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  resource_id = aws_api_gateway_resource.editfreekey.id
  http_method = aws_api_gateway_method.editfreekey.http_method
  status_code = aws_api_gateway_method_response.editfreekey-post_200.status_code
}

resource "aws_api_gateway_method_response" "editfreekey-post_200" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  resource_id = aws_api_gateway_resource.editfreekey.id
  http_method = aws_api_gateway_method.editfreekey.http_method
  status_code = "200"
  response_models = {
    "application/json": "Empty"
  }  
}


###############################################################
# 10. Resource - editrenkeikey
###############################################################
resource "aws_api_gateway_resource" "editrenkeikey" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  parent_id   = aws_api_gateway_rest_api.system_api.root_resource_id
  path_part   = "editrenkeikey"
}

resource "aws_api_gateway_method" "editrenkeikey" {
  rest_api_id   = aws_api_gateway_rest_api.system_api.id
  resource_id   = aws_api_gateway_resource.editrenkeikey.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.systemapi_authorizer.id
  api_key_required = true
}

resource "aws_api_gateway_integration" "editrenkeikey-post" {
  rest_api_id             = aws_api_gateway_rest_api.system_api.id
  resource_id             = aws_api_gateway_resource.editrenkeikey.id
  http_method             = aws_api_gateway_method.editrenkeikey.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:ap-northeast-1:lambda:path/2015-03-31/functions/arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:EditRenkeiKey/invocations"
  credentials             = "arn:aws:iam::${var.aws_account_id}:role/shusys-API-Lambda-role"
  passthrough_behavior    = "WHEN_NO_MATCH"
}

resource "aws_api_gateway_integration_response" "editrenkeikey" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  resource_id = aws_api_gateway_resource.editrenkeikey.id
  http_method = aws_api_gateway_method.editrenkeikey.http_method
  status_code = aws_api_gateway_method_response.editrenkeikey-post_200.status_code
}

resource "aws_api_gateway_method_response" "editrenkeikey-post_200" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  resource_id = aws_api_gateway_resource.editrenkeikey.id
  http_method = aws_api_gateway_method.editrenkeikey.http_method
  status_code = "200"
  response_models = {
    "application/json": "Empty"
  }  
}


###############################################################
# 11. Resource - gethistoryassessment
###############################################################
resource "aws_api_gateway_resource" "gethistoryassessment" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  parent_id   = aws_api_gateway_rest_api.system_api.root_resource_id
  path_part   = "gethistoryassessment"
}

resource "aws_api_gateway_method" "gethistoryassessment" {
  rest_api_id   = aws_api_gateway_rest_api.system_api.id
  resource_id   = aws_api_gateway_resource.gethistoryassessment.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.systemapi_authorizer.id
  api_key_required = true
}

resource "aws_api_gateway_integration" "gethistoryassessment-post" {
  rest_api_id             = aws_api_gateway_rest_api.system_api.id
  resource_id             = aws_api_gateway_resource.gethistoryassessment.id
  http_method             = aws_api_gateway_method.gethistoryassessment.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:ap-northeast-1:lambda:path/2015-03-31/functions/arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:GetHistoryAssessment/invocations"
  credentials             = "arn:aws:iam::${var.aws_account_id}:role/shusys-API-Lambda-role"
  passthrough_behavior    = "WHEN_NO_MATCH"
}

resource "aws_api_gateway_integration_response" "gethistoryassessment" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  resource_id = aws_api_gateway_resource.gethistoryassessment.id
  http_method = aws_api_gateway_method.gethistoryassessment.http_method
  status_code = aws_api_gateway_method_response.gethistoryassessment-post_200.status_code
}

resource "aws_api_gateway_method_response" "gethistoryassessment-post_200" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  resource_id = aws_api_gateway_resource.gethistoryassessment.id
  http_method = aws_api_gateway_method.gethistoryassessment.http_method
  status_code = "200"
  response_models = {
    "application/json": "Empty"
  }  
}


###############################################################
# 12. Resource - gethistoryprospect
###############################################################
resource "aws_api_gateway_resource" "gethistoryprospect" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  parent_id   = aws_api_gateway_rest_api.system_api.root_resource_id
  path_part   = "gethistoryprospect"
}

resource "aws_api_gateway_method" "gethistoryprospect" {
  rest_api_id   = aws_api_gateway_rest_api.system_api.id
  resource_id   = aws_api_gateway_resource.gethistoryprospect.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.systemapi_authorizer.id
  api_key_required = true
}

resource "aws_api_gateway_integration" "gethistoryprospect-post" {
  rest_api_id             = aws_api_gateway_rest_api.system_api.id
  resource_id             = aws_api_gateway_resource.gethistoryprospect.id
  http_method             = aws_api_gateway_method.gethistoryprospect.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:ap-northeast-1:lambda:path/2015-03-31/functions/arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:GetHistoryProspect/invocations"
  credentials             = "arn:aws:iam::${var.aws_account_id}:role/shusys-API-Lambda-role"
  passthrough_behavior    = "WHEN_NO_MATCH"
}

resource "aws_api_gateway_integration_response" "gethistoryprospect" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  resource_id = aws_api_gateway_resource.gethistoryprospect.id
  http_method = aws_api_gateway_method.gethistoryprospect.http_method
  status_code = aws_api_gateway_method_response.gethistoryprospect-post_200.status_code
}

resource "aws_api_gateway_method_response" "gethistoryprospect-post_200" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  resource_id = aws_api_gateway_resource.gethistoryprospect.id
  http_method = aws_api_gateway_method.gethistoryprospect.http_method
  status_code = "200"
  response_models = {
    "application/json": "Empty"
  }  
}


###############################################################
# 13. Resource - gettksd
###############################################################
resource "aws_api_gateway_resource" "gettksd" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  parent_id   = aws_api_gateway_rest_api.system_api.root_resource_id
  path_part   = "gettksd"
}

resource "aws_api_gateway_method" "gettksd" {
  rest_api_id   = aws_api_gateway_rest_api.system_api.id
  resource_id   = aws_api_gateway_resource.gettksd.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.systemapi_authorizer.id
  api_key_required = true
}

resource "aws_api_gateway_integration" "gettksd-post" {
  rest_api_id             = aws_api_gateway_rest_api.system_api.id
  resource_id             = aws_api_gateway_resource.gettksd.id
  http_method             = aws_api_gateway_method.gettksd.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:ap-northeast-1:lambda:path/2015-03-31/functions/arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:GetTksd/invocations"
  credentials             = "arn:aws:iam::${var.aws_account_id}:role/shusys-API-Lambda-role"
  passthrough_behavior    = "WHEN_NO_MATCH"
}

resource "aws_api_gateway_integration_response" "gettksd" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  resource_id = aws_api_gateway_resource.gettksd.id
  http_method = aws_api_gateway_method.gettksd.http_method
  status_code = aws_api_gateway_method_response.gettksd-post_200.status_code
}

resource "aws_api_gateway_method_response" "gettksd-post_200" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  resource_id = aws_api_gateway_resource.gettksd.id
  http_method = aws_api_gateway_method.gettksd.http_method
  status_code = "200"
  response_models = {
    "application/json": "Empty"
  }  
}


###############################################################
# 14. Resource - gettkyd
###############################################################
resource "aws_api_gateway_resource" "gettkyd" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  parent_id   = aws_api_gateway_rest_api.system_api.root_resource_id
  path_part   = "gettkyd"
}

resource "aws_api_gateway_method" "gettkyd" {
  rest_api_id   = aws_api_gateway_rest_api.system_api.id
  resource_id   = aws_api_gateway_resource.gettkyd.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.systemapi_authorizer.id
  api_key_required = true
}

resource "aws_api_gateway_integration" "gettkyd-post" {
  rest_api_id             = aws_api_gateway_rest_api.system_api.id
  resource_id             = aws_api_gateway_resource.gettkyd.id
  http_method             = aws_api_gateway_method.gettkyd.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:ap-northeast-1:lambda:path/2015-03-31/functions/arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:GetTkyd/invocations"
  credentials             = "arn:aws:iam::${var.aws_account_id}:role/shusys-API-Lambda-role"
  passthrough_behavior    = "WHEN_NO_MATCH"
}

resource "aws_api_gateway_integration_response" "gettkyd" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  resource_id = aws_api_gateway_resource.gettkyd.id
  http_method = aws_api_gateway_method.gettkyd.http_method
  status_code = aws_api_gateway_method_response.gettkyd-post_200.status_code
}

resource "aws_api_gateway_method_response" "gettkyd-post_200" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  resource_id = aws_api_gateway_resource.gettkyd.id
  http_method = aws_api_gateway_method.gettkyd.http_method
  status_code = "200"
  response_models = {
    "application/json": "Empty"
  }  
}


###############################################################
# 15. Resource - revivebuild
###############################################################
resource "aws_api_gateway_resource" "revivebuild" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  parent_id   = aws_api_gateway_rest_api.system_api.root_resource_id
  path_part   = "revivebuild"
}

resource "aws_api_gateway_method" "revivebuild" {
  rest_api_id   = aws_api_gateway_rest_api.system_api.id
  resource_id   = aws_api_gateway_resource.revivebuild.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.systemapi_authorizer.id
  api_key_required = true
}

resource "aws_api_gateway_integration" "revivebuild-post" {
  rest_api_id             = aws_api_gateway_rest_api.system_api.id
  resource_id             = aws_api_gateway_resource.revivebuild.id
  http_method             = aws_api_gateway_method.revivebuild.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:ap-northeast-1:lambda:path/2015-03-31/functions/arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:ReviveBuild/invocations"
  credentials             = "arn:aws:iam::${var.aws_account_id}:role/shusys-API-Lambda-role"
  passthrough_behavior    = "WHEN_NO_MATCH"
}

resource "aws_api_gateway_integration_response" "revivebuild" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  resource_id = aws_api_gateway_resource.revivebuild.id
  http_method = aws_api_gateway_method.revivebuild.http_method
  status_code = aws_api_gateway_method_response.revivebuild-post_200.status_code
}

resource "aws_api_gateway_method_response" "revivebuild-post_200" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  resource_id = aws_api_gateway_resource.revivebuild.id
  http_method = aws_api_gateway_method.revivebuild.http_method
  status_code = "200"
  response_models = {
    "application/json": "Empty"
  }  
}


###############################################################
# 16. Resource - SearchAssessmentAndProspect
###############################################################
resource "aws_api_gateway_resource" "SearchAssessmentAndProspect" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  parent_id   = aws_api_gateway_rest_api.system_api.root_resource_id
  path_part   = "SearchAssessmentAndProspect"
}

resource "aws_api_gateway_method" "SearchAssessmentAndProspect" {
  rest_api_id   = aws_api_gateway_rest_api.system_api.id
  resource_id   = aws_api_gateway_resource.SearchAssessmentAndProspect.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.systemapi_authorizer.id
  api_key_required = true
}

resource "aws_api_gateway_integration" "SearchAssessmentAndProspect-post" {
  rest_api_id             = aws_api_gateway_rest_api.system_api.id
  resource_id             = aws_api_gateway_resource.SearchAssessmentAndProspect.id
  http_method             = aws_api_gateway_method.SearchAssessmentAndProspect.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:ap-northeast-1:lambda:path/2015-03-31/functions/arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:SearchAssessmentAndProspect/invocations"
  credentials             = "arn:aws:iam::${var.aws_account_id}:role/shusys-API-Lambda-role"
  passthrough_behavior    = "WHEN_NO_MATCH"
}

resource "aws_api_gateway_integration_response" "SearchAssessmentAndProspect" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  resource_id = aws_api_gateway_resource.SearchAssessmentAndProspect.id
  http_method = aws_api_gateway_method.SearchAssessmentAndProspect.http_method
  status_code = aws_api_gateway_method_response.SearchAssessmentAndProspect-post_200.status_code
}

resource "aws_api_gateway_method_response" "SearchAssessmentAndProspect-post_200" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  resource_id = aws_api_gateway_resource.SearchAssessmentAndProspect.id
  http_method = aws_api_gateway_method.SearchAssessmentAndProspect.http_method
  status_code = "200"
  response_models = {
    "application/json": "Empty"
  }  
}


###############################################################
# 17. Resource - storetksd
###############################################################
resource "aws_api_gateway_resource" "storetksd" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  parent_id   = aws_api_gateway_rest_api.system_api.root_resource_id
  path_part   = "storetksd"
}

resource "aws_api_gateway_method" "storetksd" {
  rest_api_id   = aws_api_gateway_rest_api.system_api.id
  resource_id   = aws_api_gateway_resource.storetksd.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.systemapi_authorizer.id
  api_key_required = true
}

resource "aws_api_gateway_integration" "storetksd-post" {
  rest_api_id             = aws_api_gateway_rest_api.system_api.id
  resource_id             = aws_api_gateway_resource.storetksd.id
  http_method             = aws_api_gateway_method.storetksd.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:ap-northeast-1:lambda:path/2015-03-31/functions/arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:StoreTksd/invocations"
  credentials             = "arn:aws:iam::${var.aws_account_id}:role/shusys-API-Lambda-role"
  passthrough_behavior    = "WHEN_NO_MATCH"
}

resource "aws_api_gateway_integration_response" "storetksd" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  resource_id = aws_api_gateway_resource.storetksd.id
  http_method = aws_api_gateway_method.storetksd.http_method
  status_code = aws_api_gateway_method_response.storetksd-post_200.status_code
}

resource "aws_api_gateway_method_response" "storetksd-post_200" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  resource_id = aws_api_gateway_resource.storetksd.id
  http_method = aws_api_gateway_method.storetksd.http_method
  status_code = "200"
  response_models = {
    "application/json": "Empty"
  }  
}


###############################################################
# 18. Resource - storetkyd
###############################################################
resource "aws_api_gateway_resource" "storetkyd" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  parent_id   = aws_api_gateway_rest_api.system_api.root_resource_id
  path_part   = "storetkyd"
}

resource "aws_api_gateway_method" "storetkyd" {
  rest_api_id   = aws_api_gateway_rest_api.system_api.id
  resource_id   = aws_api_gateway_resource.storetkyd.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.systemapi_authorizer.id
  api_key_required = true
}

resource "aws_api_gateway_integration" "storetkyd-post" {
  rest_api_id             = aws_api_gateway_rest_api.system_api.id
  resource_id             = aws_api_gateway_resource.storetkyd.id
  http_method             = aws_api_gateway_method.storetkyd.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:ap-northeast-1:lambda:path/2015-03-31/functions/arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:StoreTkyd/invocations"
  credentials             = "arn:aws:iam::${var.aws_account_id}:role/shusys-API-Lambda-role"
  passthrough_behavior    = "WHEN_NO_MATCH"
}

resource "aws_api_gateway_integration_response" "storetkyd" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  resource_id = aws_api_gateway_resource.storetkyd.id
  http_method = aws_api_gateway_method.storetkyd.http_method
  status_code = aws_api_gateway_method_response.storetkyd-post_200.status_code
}

resource "aws_api_gateway_method_response" "storetkyd-post_200" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id
  resource_id = aws_api_gateway_resource.storetkyd.id
  http_method = aws_api_gateway_method.storetkyd.http_method
  status_code = "200"
  response_models = {
    "application/json": "Empty"
  }  
}

###############################################################
# Deployment
###############################################################
resource "aws_api_gateway_deployment" "systemapi_deployment" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id  
  triggers = {
    redeployment = sha1(jsonencode([
    ]))
  }
  lifecycle {
    create_before_destroy = true # change to keep
    # set prevent destroy = true
    # set ignore changes = true
  }
}


# -----------------------------------------------
# Stage - prd
# -----------------------------------------------
resource "aws_api_gateway_stage" "systemapi_prd" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id  
  deployment_id = aws_api_gateway_deployment.systemapi_deployment.id
  description = "本番用"
  stage_name = "prd"
  xray_tracing_enabled = false
}

resource "aws_api_gateway_method_settings" "systemapi_prd" {
  rest_api_id = aws_api_gateway_rest_api.system_api.id  
  stage_name  = aws_api_gateway_stage.systemapi_prd.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = false
    logging_level   = "ERROR"
    throttling_burst_limit = 5000
    throttling_rate_limit = 10000
  } 
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