######## Environment ########
aws_account_id    = "864283695195" 
region            = "ap-northeast-1"
environment       = "Production"
costcenter        = "TokyoKantei"
app_name          = "hyoka"
app_env           = "customer-1"
app_name_env_code = "hyoka-customer-1"


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

######### Cognito ########
cognito_userpool_name   = "hyoka-customer-1-cognito-userpool"