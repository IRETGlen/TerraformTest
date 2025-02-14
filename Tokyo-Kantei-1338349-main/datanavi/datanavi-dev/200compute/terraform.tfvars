######## Environment ########
aws_account_id     = "126791008945"
region             = "ap-northeast-1"
environment        = "Development"
costcenter         = "TokyoKantei"
app_name           = "datanavi"
app_env            = "dev"
app_name_env_code  = "datanavi-dev"

######## Lambda ########
//make sure to replace name to NOT OVERWRITE existing
function_name    = "new_dev_pastmap_main"
lambda_role_name = "DatanaviDev-LambdaRole"

######## API Gateway ########
//make sure to replace name to NOT OVERWRITE existing
api_name        = "new_dev_pastmap_api"
//usage_plan_name = "dev_pastmap_api_plan"

######## S3 Bucket ########
bucket_name = "new-dev-pastmap-s3"