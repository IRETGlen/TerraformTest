######## Environment ########
aws_account_id    = "489746979994" 
region            = "ap-northeast-1"
environment       = "Production"
costcenter        = "TokyoKantei"
app_name          = "reas"
app_env           = "prd"
app_name_env_code = "reas-prd"


######## EC2 ########
ubuntu_imageid     = "ami-088da9557aae42f39"
ec2_os             = "ubuntu20"
ar_resource_name   = "reas-prd-web"
internal_key_pair  = "489746979994-ap-northeast-1-reas-production-internal"


######Load Balancer ######
certificate_arn_tokyo = "arn:aws:acm:ap-northeast-1:489746979994:certificate/4b0ace5c-bf45-4516-a3ee-2e2c7eb05cb4"