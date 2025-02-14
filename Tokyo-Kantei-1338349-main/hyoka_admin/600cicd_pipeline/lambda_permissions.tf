# -----------------------------------------------
# READ ME
# -----------------------------------------------
# This scirpt will tie lambda to api gateway
# It should be run after SAM deployment of lambdas


# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:931756137289:qdcwrlyey3/*/GET/gettkyd"
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:931756137289:qdcwrlyey3/*/POST/gettkyd"

# hyoka_cloud
#     system_api = qdcwrlyey3
#     link_api = f5wzdj6h09

# hyoka_admin 
#     system_api = 3qct3xsh67
#     link_api = 7z4i6t524j

# system_api_arn = "arn:aws:execute-api:ap-northeast-1:505982390831:3qct3xsh67"
# link_api_arn   = "arn:aws:execute-api:ap-northeast-1:505982390831:7z4i6t524j"


#######################################################
######### Lambda Permissions for API Gateway ##########
#######################################################

# -----------------------------------------------
# POST Permissions List - SYSTEM API
# -----------------------------------------------
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${var.system_api_arn}/*/POST/gettkyd"
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${var.system_api_arn}/*/POST/gettksd"
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${var.system_api_arn}/*/POST/storetkyd"
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${var.system_api_arn}/*/POST/storetksd"
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${var.system_api_arn}/*/POST/deletebuild"
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${var.system_api_arn}/*/POST/actionrenkeikeyeditfreekey"
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${var.system_api_arn}/*/POST/actionrenkeikeyeditrenkeikey"
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${var.system_api_arn}/*/POST/actionrenkeikeydeletebuild"
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${var.system_api_arn}/*/POST/createcsv"
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${var.system_api_arn}/*/POST/checkloadrenkeikey"
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${var.system_api_arn}/*/POST/checkeditkey"
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${var.system_api_arn}/*/POST/editrenkeikey"
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${var.system_api_arn}/*/POST/editfreekey"
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${var.system_api_arn}/*/POST/gethistoryprospect"
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${var.system_api_arn}/*/POST/gethistoryassessment"
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${var.system_api_arn}/*/POST/revivebuild"
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${var.system_api_arn}/*/POST/startgetlistcsv"
# -----------------------------------------------

resource "aws_lambda_permission" "lambda_post_permission_systemapi" {
  for_each      = toset(var.lambda_post_permission_group_system_api)
  action        = "lambda:InvokeFunction"
  function_name = each.value
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.system_api_arn}/*/POST/${lower(each.value)}"
}

# -----------------------------------------------
# GET Permissions List - SYSTEM API
# -----------------------------------------------
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${var.system_api_arn}/*/GET/gettkyd"
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${var.system_api_arn}/*/GET/gettksd"
# -----------------------------------------------

resource "aws_lambda_permission" "lambda_get_permission_systemapi" {
  for_each      = toset(var.lambda_get_permission_group_system_api)
  action        = "lambda:InvokeFunction"
  function_name = each.value
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.system_api_arn}/*/GET/${lower(each.value)}"
}

# -----------------------------------------------
# OTHER - SYSTEM API
# -----------------------------------------------
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${var.system_api_arn}/*/POST/SearchAssessmentAndProspect"
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${var.system_api_arn}/*/*/SearchAssessmentAndProspect"
# -----------------------------------------------

resource "aws_lambda_permission" "lambda_other_permission_systemapi_1" {
  action        = "lambda:InvokeFunction"
  function_name = "SearchAssessmentAndProspect"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.system_api_arn}/*/POST/SearchAssessmentAndProspect"
}

resource "aws_lambda_permission" "lambda_other_permission_systemapi_2" {
  action        = "lambda:InvokeFunction"
  function_name = "SearchAssessmentAndProspect"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.system_api_arn}/*/*/SearchAssessmentAndProspect"
}

# -----------------------------------------------
# POST Permissions List - LINK API
# -----------------------------------------------
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${var.link_api_arn}/*/POST/startgetlistcsv"
# -----------------------------------------------

resource "aws_lambda_permission" "lambda_post_permission_linkapi" {
  action        = "lambda:InvokeFunction"
  function_name = "StartGetListCsv"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.link_api_arn}/*/POST/startgetlistcsv"
}

# -----------------------------------------------
# GET Permissions List - LINK API
# -----------------------------------------------
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${var.link_api_arn}/*/GET/getcsvurl"
# "AWS:SourceArn": "arn:aws:execute-api:ap-northeast-1:${var.aws_account_id}:"${var.link_api_arn}/*/GET/getcsvdownloadlink"
# -----------------------------------------------

resource "aws_lambda_permission" "lambda_get_permission_linkapi_1" {
  action        = "lambda:InvokeFunction"
  function_name = "GetCSVURL"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.link_api_arn}/*/GET/getcsvurl"
}

resource "aws_lambda_permission" "lambda_get_permission_linkapi_2" {
  action        = "lambda:InvokeFunction"
  function_name = "GetCSVURL"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.link_api_arn}/*/GET/getcsvdownloadlink"
}