###### RDS ######

###################
### PostgreSQL  ###
###################

module "rds" {
  source                        = "git@github.com:rackspace-infrastructure-automation/aws-terraform-rds?ref=v0.12.8"  
  auto_minor_version_upgrade    = var.rds_auto_minor_version_upgrade
  backup_retention_period       = 0
  backup_window                 = "15:45-16:15"
  cloudwatch_exports_logs_list	= ["error"]
  create_parameter_group        = false
  enable_deletion_protection    = true
  engine                        = var.rds_engine
  engine_version                = var.rds_engine_version
  environment                   = var.environment
  instance_class                = var.rds_instance_class
  internal_record_name          = var.rds_internal_record_name
  internal_zone_id              = data.terraform_remote_state.base_network.outputs.internal_hosted_zone_id
  internal_zone_name            = data.terraform_remote_state.base_network.outputs.internal_hosted_zone_name
  maintenance_window            = "sun:18:16-sun:18:46"
  max_storage_size              = 1000
  monitoring_interval           = 60
  multi_az                      = var.rds_multi_az
  name                          = var.rds_name
  rackspace_managed             = var.rds_racksapce_managed
  rackspace_alarms_enabled      = var.rds_rackspace_alarms_enabled
  security_groups               = [data.terraform_remote_state.base_network.outputs.hyoka_admin_rds_security_group]
  storage_encrypted             = false
  storage_size                  = 20
  subnets                       = [data.terraform_remote_state.base_network.outputs.private_subnet2,data.terraform_remote_state.base_network.outputs.private_subnet1]
  tags                          = local.tags
  password                      = "${data.aws_kms_secrets.rds_credentials.plaintext["password"]}"  
  create_option_group           = false
  existing_option_group_name    = aws_db_option_group.rds_option_group.name
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


#########################################
### Option Group for SQL Server Audit ###
#########################################
resource "aws_db_option_group" "rds_option_group" {
  name                     = "hyoka-admin-rds-option-group"
  option_group_description = "Terraform Option Group"
  engine_name              = "sqlserver-ex"
  major_engine_version     = "14.00"

  option {
    option_name = "SQLSERVER_AUDIT"

    option_settings {
      name = "IAM_ROLE_ARN"
      value = aws_iam_role.rds_sqlserver_audit_role.arn
    }
    option_settings {
      name = "S3_BUCKET_ARN"
      value = module.s3.bucket_arn
    }
    option_settings {
      name = "RETENTION_TIME"
      value = 0
    }    
  }
}


#####################################
### IAM Role for SQL Server Audit ###
#####################################

// ---------- Lambda IAM Role ----------
resource "aws_iam_role" "rds_sqlserver_audit_role" {
  name = "rds-sql-server-audit-role"
  # path = "/service-role/"
  assume_role_policy = <<EOF
{
	    "Version": "2012-10-17",
	    "Statement": [
	        {
	            "Effect": "Allow",
	            "Principal": {
	                "Service": "rds.amazonaws.com"
	            },
	            "Action": "sts:AssumeRole"
	        }
	    ]
	}
EOF
}

resource "aws_iam_policy" "rds_sqlserver_audit_role_policy" {
  name   = "rds-sql-server-audit-role-policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:ListAllMyBuckets",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketACL",
                "s3:GetBucketLocation"
            ],
            "Resource": "arn:aws:s3:::${var.aws_account_id}-${var.rds_sql_auditlogs_bucket_name}"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:ListMultipartUploadParts",
                "s3:AbortMultipartUpload"
            ],
            "Resource": "arn:aws:s3:::${var.aws_account_id}-${var.rds_sql_auditlogs_bucket_name}/*"
        }
    ]
}
EOF
}

// ---------- Attach Custom IAM Policies ----------
resource "aws_iam_role_policy_attachment" "attach-rds_sqlserver-audit-policy" {
  role       = aws_iam_role.rds_sqlserver_audit_role.name
  policy_arn = aws_iam_policy.rds_sqlserver_audit_role_policy.arn
}

#################################
### S3 Bucket for Audit Logs  ###
#################################

module "s3" {
  source            = "git@github.com:rackspace-infrastructure-automation/aws-terraform-s3//?ref=v0.12.3"
  bucket_acl        = "private"
  bucket_logging    = false
  environment       = var.environment
  lifecycle_enabled = false
  name              = "${var.aws_account_id}-${var.rds_sql_auditlogs_bucket_name}"

  tags = {
    Environment      = var.environment
    ServiceProvider  = "Rackspace"
  }
}

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket                  = module.s3.bucket_id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# resource "aws_s3_bucket_versioning" "bucket_versioning" {
#   bucket = module.s3.bucket_id
#   versioning_configuration {
#     status = "Disabled"
#   }
# }


# // Bucket Ownership
# resource "aws_s3_bucket_ownership_controls" "ownership_control" {
#   bucket = module.s3.bucket_id

#   rule {
#     object_ownership = "BucketOwnerEnforced"
#   }
# }