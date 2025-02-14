###############################################################################
# Environment
###############################################################################
aws_account_id    = "505982390831" 
region            = "ap-northeast-1"
environment       = "Production"
costcenter        = "TokyoKantei"
app_name          = "hyoka"
app_env           = "admin"
app_name_env_code = "hyoka-admin"

###############################################################################
# VPC
###############################################################################
az_count               = 2
cidr_range             = "10.160.13.0/24"
public_cidr_ranges     = ["10.160.13.0/26","10.160.13.64/26"]
public_subnet_names    = ["public-az"]
private_cidr_ranges    = ["10.160.13.128/26","10.160.13.192/26"]
private_subnet_names   = ["private-az"]
azs                    = ["ap-northeast-1a","ap-northeast-1c"]
private_subnets_per_az = 1
public_subnets_per_az  = 1

s3_vpce_name           = "s3-vpce"
appstream_vpce_name    = "appstream-vpce"
apigw_vpce_name        = "apigw-vpce"