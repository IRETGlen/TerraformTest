######## Environment ########
aws_account_id     = "126791008945"
region             = "ap-northeast-1"
environment        = "Staging"
costcenter         = "TokyoKantei"
app_name           = "datanavi"
app_env            = "stg"
app_name_env_code  = "datanavi-stg"

######## Lambda ########
//make sure to replace name to NOT OVERWRITE existing
function_name       = "stg_pastmap_main"
lambda_role_name    = "DatanaviStg-LambdaRole"
logging_policy_name = "Stg-LambdaLoggingPolicy"

######## API Gateway ########
//make sure to replace name to NOT OVERWRITE existing
api_name        = "stg_pastmap_api"

######## S3 Bucket ########
bucket_name = "stg-pastmap-s3"