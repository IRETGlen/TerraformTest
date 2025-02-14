module "s3" {
  source            = "git@github.com:rackspace-infrastructure-automation/aws-terraform-s3//?ref=v0.12.3"
  bucket_acl        = "private"
  bucket_logging    = false
  environment       = var.environment
  lifecycle_enabled = false
  name              = "${var.aws_account_id}-${var.bucket_name}"

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

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = module.s3.bucket_id
  versioning_configuration {
    status = "Disabled"
  }
}


// Bucket Policy
resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = module.s3.bucket_id
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.aws_account_id}:role/lambda-role"
            },
            "Action": [
                "s3:ListBucket",
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::${var.aws_account_id}-list-csv-output-destination/*",
                "arn:aws:s3:::${var.aws_account_id}-list-csv-output-destination"
            ]
        }
    ]
}
POLICY
}


// Bucket Ownership
resource "aws_s3_bucket_ownership_controls" "ownership_control" {
  bucket = module.s3.bucket_id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}