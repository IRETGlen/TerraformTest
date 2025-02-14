###### RDS ######

####################################################################################################
# PostgreSQL                                                                                    #
####################################################################################################

module "rds" {
  //source                     = "git@github.com:rackspace-infrastructure-automation/aws-terraform-rds?ref=v0.12.8"
  source                     = "./modules/rds"
  name                       = var.rds_name
  engine                     = var.rds_engine
  engine_version             = var.rds_engine_version
  instance_class             = var.rds_instance_class
  timezone                   = "Asia/Tokyo"
  subnets                    = [data.terraform_remote_state.base_network.outputs.db_private_subnet2,data.terraform_remote_state.base_network.outputs.db_private_subnet1]
  security_groups            = [data.terraform_remote_state.base_network.outputs.reas_rds_security_group]
  enable_deletion_protection = true
  multi_az                   = false
  storage_encrypted          = true
  storage_size               = 20
  max_storage_size           = 100
  password                   = "${data.aws_kms_secrets.rds_credentials.plaintext["password"]}"
  auto_minor_version_upgrade = var.rds_auto_minor_version_upgrade
  maintenance_window         = "Mon:17:00-Mon:18:00"
  backup_window              = "18:00-19:00"
  backup_retention_period    = 30
  rackspace_managed          = true
  rackspace_alarms_enabled   = var.rds_rackspace_alarms_enabled
  tags                       = local.tags
  internal_record_name       = var.rds_internal_record_name
  internal_zone_id           = data.terraform_remote_state.base_network.outputs.internal_hosted_zone_id
  internal_zone_name         = data.terraform_remote_state.base_network.outputs.internal_hosted_zone_name
  existing_parameter_group_name = aws_db_parameter_group.db_parameter_group.name
  create_parameter_group        = false
  environment                   = var.environment
  cloudwatch_exports_logs_list	= ["postgresql"]
  monitoring_interval           = 60
  
}

resource "aws_db_parameter_group" "db_parameter_group" {
  name   = "reas-rds-pg"
  family = "postgres13"

  parameter {
    name  = "timezone"
    value = "utc+9"
  }

  parameter {
    name  = "log_min_duration_statement"
    value = 1000
  }

  parameter {
    name  = "log_statement"
    value = "ddl"
  }
}

resource "aws_iam_role" "domain_join" {
  assume_role_policy = data.aws_iam_policy_document.domain_join.json
  name_prefix        = "${var.rds_name}-domain-role-"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "domain_join" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSDirectoryServiceAccess"
  role       = aws_iam_role.domain_join.name
}
