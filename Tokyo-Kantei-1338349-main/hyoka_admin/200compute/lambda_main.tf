#####################################
######### Lambda Functions ##########
#####################################

# -----------------------------------------------
# 25 Lambda Functions are defined in this file
# They are in 4 groups
# --- Group 1: timeout 30sec, runtime .NET, placed in vpc
# --- Group 2: timeout 850sec, runtime .NET, placed in vpc
# --- Group 3: other timeouts, runtime .NET, placed in vpc
# --- Group 4: runtime python, not placed in vpc
# -----------------------------------------------

# -----------------------------------------------
# GROUP 1
# -----------------------------------------------
# Role: lambda-role
# Timeout: 30sec
# Memory: 256MB
# Ephemeral Storage: 512MB
# -----------------------------------------------
# 1. GetTkyd 
# 2. StoreTkyd 
# 3. GetTksd 
# 4. StoreTksd 
# 5. DeleteBuild 
# 6. SearchAssessmentAndProspect 
# 7. ActionRenkeiKeyEditFreeKey 
# 8. ActionRenkeiKeyEditRenkeiKey 
# 9. ActionRenkeiKeyEditOptionalItem 
# 10. ActionRenkeiKeyDeleteBuild 
# 14. CheckLoadRenkeiKey 
# 21. ReviveBuild 
# -----------------------------------------------

data "archive_file" "sample"{
    type = "zip"
    output_path = "${path.module}/lambda_function_payload.zip"
    source {
        content = "hello"
        filename = "index.js"
    }
}

resource "aws_lambda_function" "lambda_function_group_1" {
  for_each      = toset(var.function_names_group_1)
  filename      = data.archive_file.sample.output_path
  function_name = each.value
  role          = aws_iam_role.hyoka_lambda_role.arn
  handler       = "index.handler"
  runtime       = "dotnet6"
  timeout       = 30
  memory_size   = 256

  vpc_config {
    subnet_ids         = [data.terraform_remote_state.base_network.outputs.private_subnet1,data.terraform_remote_state.base_network.outputs.private_subnet2]
    security_group_ids = [data.terraform_remote_state.base_network.outputs.hyoka_admin_lambda_security_group]
  }

  environment {
    variables = {
      ODBCINI  = "/opt/odbc.ini",
      ODBCSYSINI  = "/opt"
    }
  }

  tags = {
    Environment     = var.environment
    ServiceProvider = "Rackspace"
  }
}


# -----------------------------------------------
# GROUP 2
# -----------------------------------------------
# Role: lambda-role
# Timeout: 14min 10sec (850 sec)
# Memory: 256MB
# Ephemeral Storage: 512MB
# -----------------------------------------------
# 11. CreateCsv
# 13. CreateListCsvProspect
# 15. CheckEditKey
# 17. EditRenkeiKey
# 18. EditFreeKey
# 19. GetHistoryProspect
# 20. GetHistoryAssessment
# 22. StartGetListCsv
# 23. StartGetListCsvProspect
# -----------------------------------------------

resource "aws_lambda_function" "lambda_function_group_2" {
  for_each      = toset(var.function_names_group_2)
  filename      = data.archive_file.sample.output_path
  function_name = each.value
  role          = aws_iam_role.hyoka_lambda_role.arn
  handler       = "index.handler"
  runtime       = "dotnet6"
  timeout       = 850
  memory_size   = 256

  vpc_config {
    subnet_ids         = [data.terraform_remote_state.base_network.outputs.private_subnet1,data.terraform_remote_state.base_network.outputs.private_subnet2]
    security_group_ids = [data.terraform_remote_state.base_network.outputs.hyoka_admin_lambda_security_group]
  }

  environment {
    variables = {
      ODBCINI  = "/opt/odbc.ini",
      ODBCSYSINI  = "/opt"
    }
  }

  tags = {
    Environment     = var.environment
    ServiceProvider = "Rackspace"
  }
}


# -----------------------------------------------
# GROUP 3
# -----------------------------------------------
# 12. CreateListCsv
# Role: lambda-role
# Timeout: 14min 55sec (895 sec)
# Memory: 256MB
# Ephemeral Storage: 512MB
# -----------------------------------------------
# 16. CombineListCsv
# Role: lambda-role
# Timeout: 14min 50sec (890 sec)
# Memory: 256MB
# Ephemeral Storage: 512MB
# -----------------------------------------------

resource "aws_lambda_function" "lambda_function_group_3" {
  for_each      = var.function_names_group_3
  filename      = data.archive_file.sample.output_path
  function_name = each.value.name
  role          = aws_iam_role.hyoka_lambda_role.arn
  handler       = "index.handler"
  runtime       = "dotnet6"
  timeout       = each.value.timeout
  memory_size   = 256

  vpc_config {
    subnet_ids         = [data.terraform_remote_state.base_network.outputs.private_subnet1,data.terraform_remote_state.base_network.outputs.private_subnet2]
    security_group_ids = [data.terraform_remote_state.base_network.outputs.hyoka_admin_lambda_security_group]
  }

  environment {
    variables = {
      ODBCINI  = "/opt/odbc.ini",
      ODBCSYSINI  = "/opt"
    }
  }

  tags = {
    Environment     = var.environment
    ServiceProvider = "Rackspace"
  }
}


# -----------------------------------------------
# GROUP 4
# 24. GetCSVURL
# 25. pass-large-payload
# -----------------------------------------------

# -----------------------------------------------
# 24. GetCSVURL
# Role: GetCSVURL_role
# Timeout: 10 sec
# Memory; 128MB
# Ephemeral Storage: 512MB
# Runtime: Python 3.9
# -----------------------------------------------

resource "aws_lambda_function" "lambda_GetCSVURL" {
  filename      = data.archive_file.sample.output_path
  function_name = "GetCSVURL"
  role          = aws_iam_role.hyoka_GetCSVURL_role.arn
  handler       = "index.handler"
  runtime       = "python3.9"
  timeout       = 10
  memory_size   = 128

  tags = {
    Environment     = var.environment
    ServiceProvider = "Rackspace"
  }
}


# -----------------------------------------------
# 25. pass-large-payload
# Role: lambda-role
# Timeout: 3 sec
# Memory; 128MB
# Ephemeral Storage: 512MB
# Runtime: Python 3.9
# -----------------------------------------------

resource "aws_lambda_function" "lambda_pass_large_payload" {
  filename      = data.archive_file.sample.output_path
  function_name = "pass-large-payload"
  role          = aws_iam_role.hyoka_lambda_role.arn
  handler       = "index.handler"
  runtime       = "python3.9"
  timeout       = 3
  memory_size   = 128

  tags = {
    Environment     = var.environment
    ServiceProvider = "Rackspace"
  }
}


#########################################
######### CloudWatch Log Group ##########
#########################################

# CloudWatch Log Group - Retention: 7 days
resource "aws_cloudwatch_log_group" "function_cwlog_group_retention_7days" {
  for_each          = toset(var.cwloggroup_retention_7days)
  name              = "/aws/lambda/${each.value}"
  retention_in_days = 7
  lifecycle {
    prevent_destroy = false
  }
}

# CloudWatch Log Group - Retention: Never expire
resource "aws_cloudwatch_log_group" "function_cwlog_group_retention_neverexpire" {
  for_each          = toset(var.cwloggroup_retention_neverexpire)
  name              = "/aws/lambda/${each.value}"
  retention_in_days = 0
  lifecycle {
    prevent_destroy = false
  }
}


#######################################################
######### Lambda Permissions for API Gateway ##########
#######################################################

# -----------------------------------------------
# POST Permissions List - SYSTEM API
# -----------------------------------------------
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${aws_api_gateway_rest_api.system_api.execution_arn}/*/POST/gettkyd"
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${aws_api_gateway_rest_api.system_api.execution_arn}/*/POST/gettksd"
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${aws_api_gateway_rest_api.system_api.execution_arn}/*/POST/storetkyd"
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${aws_api_gateway_rest_api.system_api.execution_arn}/*/POST/storetksd"
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${aws_api_gateway_rest_api.system_api.execution_arn}/*/POST/deletebuild"
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${aws_api_gateway_rest_api.system_api.execution_arn}/*/POST/actionrenkeikeyeditfreekey"
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${aws_api_gateway_rest_api.system_api.execution_arn}/*/POST/actionrenkeikeyeditrenkeikey"
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${aws_api_gateway_rest_api.system_api.execution_arn}/*/POST/actionrenkeikeydeletebuild"
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${aws_api_gateway_rest_api.system_api.execution_arn}/*/POST/createcsv"
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${aws_api_gateway_rest_api.system_api.execution_arn}/*/POST/checkloadrenkeikey"
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${aws_api_gateway_rest_api.system_api.execution_arn}/*/POST/checkeditkey"
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${aws_api_gateway_rest_api.system_api.execution_arn}/*/POST/editrenkeikey"
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${aws_api_gateway_rest_api.system_api.execution_arn}/*/POST/editfreekey"
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${aws_api_gateway_rest_api.system_api.execution_arn}/*/POST/gethistoryprospect"
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${aws_api_gateway_rest_api.system_api.execution_arn}/*/POST/gethistoryassessment"
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${aws_api_gateway_rest_api.system_api.execution_arn}/*/POST/revivebuild"
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${aws_api_gateway_rest_api.system_api.execution_arn}/*/POST/startgetlistcsv"
# -----------------------------------------------

resource "aws_lambda_permission" "lambda_post_permission_systemapi" {
  for_each      = toset(var.lambda_post_permission_group_system_api)
  action        = "lambda:InvokeFunction"
  function_name = each.value
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.system_api.execution_arn}/*/POST/${lower(each.value)}"
}

# -----------------------------------------------
# GET Permissions List - SYSTEM API
# -----------------------------------------------
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${aws_api_gateway_rest_api.system_api.execution_arn}/*/GET/gettkyd"
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${aws_api_gateway_rest_api.system_api.execution_arn}/*/GET/gettksd"
# -----------------------------------------------

resource "aws_lambda_permission" "lambda_get_permission_systemapi" {
  for_each      = toset(var.lambda_get_permission_group_system_api)
  action        = "lambda:InvokeFunction"
  function_name = each.value
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.system_api.execution_arn}/*/GET/${lower(each.value)}"
}

# -----------------------------------------------
# OTHER - SYSTEM API
# -----------------------------------------------
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${aws_api_gateway_rest_api.system_api.execution_arn}/*/POST/SearchAssessmentAndProspect"
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${aws_api_gateway_rest_api.system_api.execution_arn}/*/*/SearchAssessmentAndProspect"
# -----------------------------------------------

resource "aws_lambda_permission" "lambda_other_permission_systemapi_1" {
  action        = "lambda:InvokeFunction"
  function_name = "SearchAssessmentAndProspect"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.system_api.execution_arn}/*/POST/SearchAssessmentAndProspect"
}

resource "aws_lambda_permission" "lambda_other_permission_systemapi_2" {
  action        = "lambda:InvokeFunction"
  function_name = "SearchAssessmentAndProspect"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.system_api.execution_arn}/*/*/SearchAssessmentAndProspect"
}

# -----------------------------------------------
# POST Permissions List - LINK API
# -----------------------------------------------
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${aws_api_gateway_rest_api.link_api.execution_arn}/*/POST/startgetlistcsv"
# -----------------------------------------------

resource "aws_lambda_permission" "lambda_post_permission_linkapi" {
  action        = "lambda:InvokeFunction"
  function_name = "StartGetListCsv"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.system_api.execution_arn}/*/POST/startgetlistcsv"
}

# -----------------------------------------------
# GET Permissions List - LINK API
# -----------------------------------------------
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${aws_api_gateway_rest_api.link_api.execution_arn}/*/GET/getcsvurl"
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${aws_api_gateway_rest_api.link_api.execution_arn}/*/GET/getcsvdownloadlink"
# -----------------------------------------------

resource "aws_lambda_permission" "lambda_get_permission_linkapi_1" {
  action        = "lambda:InvokeFunction"
  function_name = "GetCSVURL"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.system_api.execution_arn}/*/GET/getcsvurl"
}

resource "aws_lambda_permission" "lambda_get_permission_linkapi_2" {
  action        = "lambda:InvokeFunction"
  function_name = "GetCSVURL"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.system_api.execution_arn}/*/GET/getcsvdownloadlink"
}