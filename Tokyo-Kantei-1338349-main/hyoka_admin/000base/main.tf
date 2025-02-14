###############################################################################
#########################         000base Layer       #########################
###############################################################################

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

data "aws_caller_identity" "current" {}

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
    key     = "terraform.prd.000base.tfstate"
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

###############################################################################
# Base Network
# https://github.com/rackspace-infrastructure-automation/aws-terraform-vpc_basenetwork
###############################################################################
module "base_network" {
  source                        = "git@github.com:rackspace-infrastructure-automation/aws-terraform-vpc_basenetwork//?ref=v0.12.2"
  name                          = "${var.app_name_env_code}-vpc"
  build_s3_flow_logs            = true
  cidr_range                    = var.cidr_range
  custom_azs                    = var.azs
  private_subnet_names          = var.private_subnet_names
  public_subnet_names           = var.public_subnet_names
  private_subnets_per_az        = var.private_subnets_per_az
  az_count                      = var.az_count
  public_subnets_per_az         = var.public_subnets_per_az
  private_cidr_ranges           = var.private_cidr_ranges
  public_cidr_ranges            = var.public_cidr_ranges  
  environment                   = var.environment
  build_vpn                     = false
  default_tenancy               = "default"
  tags                          = local.tags
  logging_bucket_force_destroy  = true
  logging_bucket_name           = "${data.aws_caller_identity.current.account_id}-${var.app_name}-vpc-flowlogs"
  logging_bucket_prefix         = "${data.aws_caller_identity.current.account_id}-${var.app_name}-vpc-flowlogs"
  logging_bucket_access_control = "bucket-owner-full-control"
  build_nat_gateways            = true
  single_nat                    = true
  # map_public_ip_on_launch       = false

  # pulled from terraformer 
  # assign_generated_ipv6_cidr_block     = "false"
  # enable_classiclink                   = "false"
  # enable_classiclink_dns_support       = "false"
  # enable_dns_hostnames                 = "true"
  # enable_dns_support                   = "true"
  # enable_network_address_usage_metrics = "false"
  # instance_tenancy                     = "default"
  # ipv6_netmask_length                  = "0"  
}

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = "${data.aws_caller_identity.current.account_id}-${var.app_name}-vpc-flowlogs"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

###############################################################################
# SNS
###############################################################################
module "sns_topic" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-sns//?ref=v0.12.0"
  name   = "${var.app_name_env_code}-sns-topic"
}

###############################################################################
# Route53 Internal Zone
###############################################################################
module "internal_zone" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-route53_internal_zone//?ref=v0.12.0"

  tags        = local.tags
  environment = var.environment
  vpc_id      = module.base_network.vpc_id
  name        = "hyoka-${lower(var.environment)}.local"
}