module "s3" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-s3//?ref=v0.12.3"

  bucket_acl                                 = "private"
  bucket_logging                             = false
  environment                                = var.environment
  lifecycle_enabled                          = false
  name                                       = var.bucket_name
  tags = {
    Environment      = var.environment
    ServiceProvider  = "Rackspace"
  }
}


resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = module.s3.bucket_id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = module.s3.bucket_id
  versioning_configuration {
    status = "Disabled"
  }
}

// Bucket Policy
resource "aws_s3_bucket_policy" "allow_access_from_lambda" {
  bucket = module.s3.bucket_id
  policy = data.aws_iam_policy_document.allow_access_from_lambda.json
}

data "aws_iam_policy_document" "allow_access_from_lambda" {
  statement {
    sid       = "PublicReadGetObject"
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.bucket_name}/*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceVpc"
      values   = [data.terraform_remote_state.base_network.outputs.vpc_id]
    }
  }
}

// Bucket Ownership
resource "aws_s3_bucket_ownership_controls" "ownership_control" {
  bucket = module.s3.bucket_id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}