###############################################################################
# Providers
###############################################################################
provider "aws" {
  version             = "~> 2.0"
  region              = var.region
  allowed_account_ids = [var.aws_account_id]
}

provider "random" {
  version = "~> 2.0"
}

provider "template" {
  version = "~> 2.0"
}

locals {
  tags = {
    ServiceProvider = "Rackspace"
    Environment     = var.environment
    CostCenter      = var.costcenter
  }
}

###############################################################################
# Terraform main config
# terraform block cannot be interpolated; sample provided as output of _main
# `terraform output remote_state_configuration_example`
###############################################################################
terraform {
  required_version = ">= 0.12"

  backend "s3" {
    # Get S3 Bucket name from layer _main (`terraform output state_bucket_id`)
    bucket  = "505982390831-hyoka-tokyo-build-state-bucket"
    # This key must be unique for each layer!
    key     = "terraform.prd.100base.tfstate"
    region  = "ap-northeast-1"
    encrypt = "true"
  }
}

###############################################################################
# Terraform Remote State 
###############################################################################
data "terraform_remote_state" "main_state" {
  backend = "local"

  config = {
    path = "../_main/terraform.tfstate"
  }
}

data "terraform_remote_state" "base_network" {
  backend = "s3"

  config = {
    bucket  = "505982390831-hyoka-tokyo-build-state-bucket"
    key     = "terraform.prd.000base.tfstate"
    region  = var.region
    encrypt = "true"
  }
}

resource "random_string" "rds_password" {
  length  = 20
  lower   = true
  upper   = true
  number  = true
  special = false
}
 
data "aws_kms_secrets" "rds_credentials" {
  secret {
    name    = "password"
    payload = file("${path.module}/rds-password-encrypted.txt")
    }
 }

resource "aws_secretsmanager_secret" "rds_password" {
  name    = "${lower(var.app_name_env_code)}-rds-password"
  recovery_window_in_days = 0
  tags = local.tags
}
 
resource "aws_secretsmanager_secret_version" "rds_password" {
  secret_id     = aws_secretsmanager_secret.rds_password.id
  secret_string = random_string.rds_password.result
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      identifiers = ["monitoring.rds.amazonaws.com"]
      type        = "Service"
    }
  }
}

data "aws_iam_policy_document" "domain_join" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      identifiers = ["rds.amazonaws.com"]
      type        = "Service"
    }
  }
}
