########### RDS #############

#############################
### Aurora Serverless v2  ###
#############################

resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier               = var.rds_name
  engine                           = var.rds_engine
  engine_mode                      = var.rds_engine_mode
  engine_version                   = var.rds_engine_version
  
  master_username                  = file("${path.module}/rds-username.txt")
  master_password                  = file("${path.module}/rds-password.txt")

  storage_encrypted                = true
  skip_final_snapshot              = true
  db_subnet_group_name             = aws_db_subnet_group.aurora_subnetgroup.name
  vpc_security_group_ids           = var.rds_security_group_ids
  db_instance_parameter_group_name = aws_rds_cluster_parameter_group.babelfish_compatible_pg.name
  backup_retention_period          = 1
  preferred_maintenance_window     = "sun:18:16-sun:18:46"
  preferred_backup_window          = "15:45-16:15"
  copy_tags_to_snapshot            = true

  serverlessv2_scaling_configuration {
    max_capacity = 4.0
    min_capacity = 0.5
  }
}

resource "aws_db_subnet_group" "aurora_subnetgroup" {
  name       = var.rds_subnet_group_name
  subnet_ids = var.rds_subnet_ids
}

resource "aws_rds_cluster_instance" "aurora_cluster_instances" {
  count                        = 1
  cluster_identifier           = aws_rds_cluster.aurora_cluster.id
  engine                       = aws_rds_cluster.aurora_cluster.engine
  engine_version               = aws_rds_cluster.aurora_cluster.engine_version
  db_subnet_group_name         = aws_db_subnet_group.aurora_subnetgroup.name
  identifier                   = var.rds_name
  instance_class               = var.rds_instance_class
  promotion_tier               = 1
  preferred_maintenance_window = "sun:18:16-sun:18:46"
  auto_minor_version_upgrade   = true
}

resource "aws_rds_cluster_parameter_group" "babelfish_compatible_pg" {
  name        = var.rds_cluster_parameter_group_name
  family      = var.rds_cluster_parameter_family
  description = "RDS babelfish compatible cluster parameter group"

  parameter {
    name  = "autovacuum_vacuum_insert_scale_factor "
    value = 0.2
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "babelfishpg_tsql.default_locale"
    value = "ja-JP"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "log_statement"
    value = "none"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "rds.babelfish_status"
    value = "on"
    apply_method = "pending-reboot"
  }
}