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
# RDS
###############################################################################
rds_name                       = "reas-prd-rds"
rds_engine                     = "postgres"
rds_engine_version             = "13"
rds_instance_class             = "db.t3.small"
rds_auto_minor_version_upgrade = true
rds_rackspace_alarms_enabled   = false
rds_internal_record_name       = "reas-prd-rds-internal-record"
rds_password                   = file("${path.module}/rds-password.txt")


###############################################################################
# SNS
###############################################################################
###### SNS ###### 
# notification_name = "[SNS TOPIC NAME]"