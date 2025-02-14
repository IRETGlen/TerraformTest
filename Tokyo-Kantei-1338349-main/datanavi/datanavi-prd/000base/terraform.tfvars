###############################################################################
# Environment
###############################################################################
aws_account_id    = "126791008945" 
region            = "ap-northeast-1"
environment       = "Production"
costcenter        = "TokyoKantei"
app_name          = "datanavi"
app_env           = "prd"
app_name_env_code = "datanavi-prd"

###############################################################################
# VPC
###############################################################################
az_count               = 2
cidr_range             = "10.153.0.0/16"
public_cidr_ranges     = ["10.153.1.0/24","10.153.2.0/24"]
public_subnet_names    = ["public-az"]
private_cidr_ranges    = ["10.153.3.0/24","10.153.4.0/24"]
private_subnet_names   = ["private-az"]
azs                    = ["ap-northeast-1a","ap-northeast-1c"]
private_subnets_per_az = 1
public_subnets_per_az  = 1
vpce_name              = "prd-pastmap-s3"
