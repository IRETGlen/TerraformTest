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
# RDS
###############################################################################
rds_name                       = "hyoka-admin-rds"
rds_engine                     = "sqlserver-ex"
rds_engine_version             = "14.00.3421.10.v1"
rds_instance_class             = "db.t3.medium"
rds_auto_minor_version_upgrade = false
rds_rackspace_alarms_enabled   = true
rds_racksapce_managed          = false
rds_multi_az                   = false
rds_internal_record_name       = "hyoka-admin-rds-internal-record"
rds_sql_auditlogs_bucket_name  = "hyoka-admin-rds-audit-log"

###############################################################################
# SNS
###############################################################################
###### SNS ###### 
# notification_name = "[SNS TOPIC NAME]"