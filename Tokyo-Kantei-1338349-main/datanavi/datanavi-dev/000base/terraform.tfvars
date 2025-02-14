###############################################################################
# Environment
###############################################################################
aws_account_id    = "126791008945" 
region            = "ap-northeast-1"
environment       = "Development"
costcenter        = "TokyoKantei"
app_name          = "datanavi"
app_env           = "dev"
app_name_env_code = "datanavi-dev"

###############################################################################
# VPC
###############################################################################
az_count               = 1
cidr_range             = "10.151.0.0/16"
public_cidr_ranges     = ["10.151.1.0/24"]
public_subnet_names    = ["public-az"]
private_cidr_ranges    = ["10.151.2.0/24"]
private_subnet_names   = ["private-az"]
azs                    = ["ap-northeast-1a"]
private_subnets_per_az = 1
public_subnets_per_az  = 1
vpce_name              = "new-dev-pastmap-s3"
