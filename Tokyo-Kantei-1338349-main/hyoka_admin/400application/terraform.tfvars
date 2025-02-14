######## Environment ########
aws_account_id    = "505982390831" 
region            = "ap-northeast-1"
environment       = "Production"
costcenter        = "TokyoKantei"
app_name          = "hyoka"
app_env           = "admin"
app_name_env_code = "hyoka-admin"


######## AppStream ########
image_arn               = "arn:aws:appstream:ap-northeast-1:931756137289:image/shusys_bulk"
stack_name              = "hyoka-admin-appstream-stack"
fleet_name              = "hyoka-admin-appstream-fleet"
fleet_type              = "ON_DEMAND"
minimum_capacity        = 1
maximum_capacity        = 5
desired_capacity        = 1
appstream_instance_type = "stream.standard.medium"

# pull this from tf data in future builds 
# currently hardcoded since this build layer was added 40 days after original bulid and tf state data has been removed
appstream_fleet_sgs     = ["sg-053f019b503a32cd5"]
appstream_subnet_ids    = ["subnet-0a509cef98d25d413","subnet-05940c15165934bd2"] 


######## AppStream ########
cognito_userpool_name   = "hyoka-admin-cognito-userpool"