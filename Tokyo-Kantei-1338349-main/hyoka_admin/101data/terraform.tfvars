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
# this rds was added on Jun 19 2023, 2 months after the original build. 
# some variables below are hardcoded because the remote state file has expired.
rds_name                         = "hyoka-admin-aurora-rds"
rds_engine                       = "aurora-postgresql"
rds_engine_mode                  = "provisioned"
rds_engine_version               = "14.6"
rds_security_group_ids           = ["sg-0cc9993b1fa15e90c"]
rds_subnet_group_name            = "hyoka-admin-aurora-rds-subnet-group"
rds_subnet_ids                   = ["subnet-069a84c078820d855","subnet-06852bf487a9374ba"]
rds_instance_class               = "db.serverless"
rds_cluster_parameter_group_name = "hyoka-admin-aurora-babelfish-pg"
rds_cluster_parameter_family     = "aurora-postgresql14"
