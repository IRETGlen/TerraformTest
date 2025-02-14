###############################################################################
# Environment
###############################################################################
aws_account_id    = "489746979994" 
region            = "ap-northeast-1"
environment       = "Production"
costcenter        = "TokyoKantei"
app_name          = "reas"
app_env           = "prd"
app_name_env_code = "reas-prd"

###############################################################################
# VPC
###############################################################################
az_count               = 2
cidr_range             = "10.156.0.0/16"
public_cidr_ranges     = ["10.156.0.0/24","10.156.1.0/24"]
public_subnet_names    = ["public-az"]
private_cidr_ranges    = ["10.156.2.0/24","10.156.3.0/24","10.156.4.0/24","10.156.5.0/24"]
private_subnet_names   = ["private-web-az","private-db-az"]
azs                    = ["ap-northeast-1a","ap-northeast-1c"]
private_subnets_per_az = 2
public_subnets_per_az  = 1