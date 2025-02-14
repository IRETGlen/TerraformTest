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

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = "~> 4.4"
    random = "~> 2.0"
    template = "~> 2.0"
  }
}

# pinned provider versions

provider "aws" {
  region              = var.region
  allowed_account_ids = [var.aws_account_id]
}


data "aws_caller_identity" "current" {}

locals {
  # Add additional tags in the below map
  tags = {
    ServiceProvider = "Rackspace"
  }
}

resource "aws_s3_bucket" "state" {
  bucket        = "${data.aws_caller_identity.current.account_id}-pipeline-build-state-bucket"
  force_destroy = true

  tags = local.tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state" {
  bucket = aws_s3_bucket.state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "state" {
  bucket  = aws_s3_bucket.state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "state" {
  bucket = aws_s3_bucket.state.id

  rule {
    id      = "Expire90"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 90
    }

    expiration {
      days = 90
    }
  }
}

/* 
resource "aws_s3_bucket_acl" "state_bucket_acl" {
  bucket = aws_s3_bucket.state.id
  acl    = "private"
}
 */