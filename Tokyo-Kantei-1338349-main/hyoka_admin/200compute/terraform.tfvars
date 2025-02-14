######## Environment ########
aws_account_id    = "505982390831" 
region            = "ap-northeast-1"
environment       = "Production"
costcenter        = "TokyoKantei"
app_name          = "hyoka"
app_env           = "admin"
app_name_env_code = "hyoka-admin"

######## IAM Roles ########
iam_role_shusys_step_lambda = "shusys-step-lambda-role"
iam_role_lambda             = "lambda-role"
iam_role_get_csv_url        = "GetCSVURL_role"
iam_role_shusys_api_lambda  = "shusys-API-Lambda-role"
iam_role_api_stepfunctions  = "API-StepFunctions-role"
iam_user                    = "shusys-sv"
# logging_policy_name = "Prd-LambdaLoggingPolicy"

######### API Gateway ########
system_api_name  = "SYSTEM API"
link_api_name    = "LINK API"

######## Lambda ########
function_names_group_1 = [
    "GetTkyd",
    "StoreTkyd",
    "GetTksd",
    "StoreTksd", 
    "DeleteBuild", 
    "SearchAssessmentAndProspect", 
    "ActionRenkeiKeyEditFreeKey", 
    "ActionRenkeiKeyEditRenkeiKey", 
    "ActionRenkeiKeyEditOptionalItem",
    "ActionRenkeiKeyDeleteBuild",
    "CheckLoadRenkeiKey",
    "ReviveBuild"
]

function_names_group_2 = [
    "CreateCsv",
    "CreateListCsvProspect",
    "CheckEditKey",
    "EditRenkeiKey",
    "EditFreeKey",
    "GetHistoryProspect",
    "GetHistoryAssessment",
    "StartGetListCsv",
    "StartGetListCsvProspect"
]

function_names_group_3 = {
    function1 = {
      name = "CreateListCsv"
      timeout = 895
    }
    function2 = {
      name = "CombineListCsv"
      timeout = 890
    }
}

######## CloudWatch Log Groups ########
cwloggroup_retention_7days = [
  "GetTkyd",
  "StoreTkyd",
  "GetTksd",
  "StoreTksd",
  "SearchAssessmentAndProspect",
  "CreateListCsv",
  "CombineListCsv",
  "StartGetListCsv",
  "GetCSVURL",
  "pass-large-payload"
]

cwloggroup_retention_neverexpire = [
  "DeleteBuild",
  "ActionRenkeiKeyEditFreeKey",
  "ActionRenkeiKeyEditRenkeiKey", 
  "ActionRenkeiKeyEditOptionalItem", 
  "ActionRenkeiKeyDeleteBuild",
  "CheckLoadRenkeiKey",
  "ReviveBuild",
  "CreateCsv",
  "CreateListCsvProspect",
  "CheckEditKey",
  "EditRenkeiKey",
  "EditFreeKey",
  "GetHistoryProspect",
  "GetHistoryAssessment",
  "StartGetListCsvProspect"
]

######## Lambda API Gateway Permission ########
lambda_post_permission_group_system_api = [
  "GetTkyd",
  "GetTksd",
  "StoreTkyd",
  "StoreTksd",
  "DeleteBuild",
  "ActionRenkeiKeyEditFreeKey",
  "ActionRenkeiKeyEditRenkeiKey",
  "ActionRenkeiKeyDeleteBuild",
  "CreateCsv",
  "CheckLoadRenkeiKey",
  "CheckEditKey",
  "EditRenkeiKey",
  "EditFreeKey",
  "GetHistoryProspect",
  "GetHistoryAssessment",
  "ReviveBuild",
  "StartGetListCsv"
]

lambda_get_permission_group_system_api = [
  "GetTkyd",
  "GetTksd"
]