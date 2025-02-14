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
# RDS
###############################################################################
# this rds was added on Jun 19 2023, 2 months after the original build. 
# some variables below are hardcoded because the remote state file has expired.
rds_name                         = "hyoka-customer-1-aurora-rds"
rds_engine                       = "aurora-postgresql"
rds_engine_mode                  = "provisioned"
rds_engine_version               = "15.3"
rds_subnet_group_name            = "hyoka-customer-1-aurora-rds-subnet-group"
rds_instance_class               = "db.serverless"
rds_cluster_parameter_group_name = "hyoka-customer-1-aurora-babelfish-pg-15"
rds_cluster_parameter_family     = "aurora-postgresql15"
rds_snapshot_id                  = "arn:aws:rds:ap-northeast-1:505982390831:cluster-snapshot:hyoka-admin-aurora-rds-230912-enc"
