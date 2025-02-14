######## Environment ########
aws_account_id     = "126791008945"
region             = "ap-northeast-1"
environment        = "Produciton"
costcenter         = "TokyoKantei"
app_name           = "datanavi"
app_env            = "prd"
app_name_env_code  = "datanavi-prd"

######## Lambda ########
//make sure to replace name to NOT OVERWRITE existing
function_name       = "prd_pastmap_main"
lambda_role_name    = "DatanaviPrd-LambdaRole"
logging_policy_name = "Prd-LambdaLoggingPolicy"

######## API Gateway ########
//make sure to replace name to NOT OVERWRITE existing
api_name        = "prd_pastmap_api"

######## S3 Bucket ########
bucket_name = "prd-pastmap-s3"