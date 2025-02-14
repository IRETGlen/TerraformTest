###############################################################################
# Environment
###############################################################################
aws_account_id    = "864283695195" 
region            = "ap-northeast-1"
environment       = "Production"
costcenter        = "TokyoKantei"
app_name          = "hyoka"
app_env           = "customer-1"
app_name_env_code = "hyoka-customer-1"

###############################################################################
# VPC
###############################################################################
az_count               = 2
cidr_range             = "10.160.100.0/24"
public_cidr_ranges     = ["10.160.100.0/26","10.160.100.64/26"]
public_subnet_names    = ["public-az"]
private_cidr_ranges    = ["10.160.100.128/26","10.160.100.192/26"]
private_subnet_names   = ["private-az"]
azs                    = ["ap-northeast-1a","ap-northeast-1c"]
private_subnets_per_az = 1
public_subnets_per_az  = 1

tokyo_kantei_cidr      = ["140.227.46.69/32"]
iij_cidr               = ["10.11.0.0/16"]

apigw_vpce_name        = "apigw-vpce"
s3_vpce_interface_name = "s3-vpce-if"
s3_vpce_gateway_name   = "s3-vpce"
