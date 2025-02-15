/**
 * # Initialisation
 *
 * This layer is used to create a S3 bucket for remote state storage.
 *
 * ### Create
 *
 * Update the `terraform.tfvars` file to include your account ID and region. This is just for the state bucket and not for where you are deploying your code so you can choose to place the bucket in a location closer to you than the target for the build.
 *
 * - generate AWS temporary credentials (see FAWS Janus)
 * - update terraform.tfvars with your environent and region
 *
 * ```bash
 * $ terraform init
 * $ terraform apply -auto-approve
 * ```
 *
 * ### Destroy
 *
 * * generate AWS temporary credentials (see FAWS Janus)
 *
 * ```bash
 * $ terraform destroy
 * ```
 *
 * When prompted, check the plan and then respond in the affirmative.
 */

###############################################################################
# Providers
###############################################################################
provider "aws" {
  version             = "~> 2.17"
  region              = var.region
  allowed_account_ids = [var.aws_account_id]
}

###############################################################################
# Use Terraform Version 0.12
###############################################################################
terraform {
  required_version = ">= 0.12"
}


###############################################################################
# S3 Bucket for Terraform state
###############################################################################
data "aws_caller_identity" "current" {}

locals {
  # Add additional tags in the below map
  tags = {
    ServiceProvider = "Rackspace"
    Environment     = var.environment
  }
}

resource "aws_s3_bucket" "state" {
  bucket        = "${data.aws_caller_identity.current.account_id}-reas-prd-tokyo-build-state-bucket"
  force_destroy = true
  region        = var.region
  tags          = local.tags

  lifecycle_rule {
    id      = "Expire30"
    enabled = true
    noncurrent_version_expiration {
      days = 30
    }
    expiration {
      days = 30
    }
  }
  
  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}