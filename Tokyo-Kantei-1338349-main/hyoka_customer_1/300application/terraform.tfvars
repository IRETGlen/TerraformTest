######## Environment ########
aws_account_id    = "864283695195" 
region            = "ap-northeast-1"
environment       = "Production"
costcenter        = "TokyoKantei"
app_name          = "hyoka"
app_env           = "customer-1"
app_name_env_code = "hyoka-customer-1"


######## AppStream ########
image_arn               = "arn:aws:appstream:ap-northeast-1:931756137289:image/shusys_bulk"
stack_name              = "hyoka-customer-1-appstream-stack"
fleet_name              = "hyoka-customer-1-appstream-fleet"
fleet_type              = "ON_DEMAND"
minimum_capacity        = 1
maximum_capacity        = 5
desired_capacity        = 1
appstream_instance_type = "stream.standard.medium"
