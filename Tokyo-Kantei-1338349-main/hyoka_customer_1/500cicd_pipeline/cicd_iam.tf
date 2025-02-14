# -----------------------------------------------
# Create the IAM Roles below to enable CICD Pipeline execution from hyoka_admin
#
# 1. AWSCloudFormationStackSetExecutionRole
# 2. cross-account-cicd-cloudformation-service-role
# 3. cross-account-cicd-assume-role
# -----------------------------------------------

# -----------------------------------------------
# 1. AWSCloudFormationStackSetExecutionRole
# -----------------------------------------------

// ---------- IAM Role ----------
resource "aws_iam_role" "hyoka_AWSCloudFormationStackSetExecutionRole" {
  name = "AWSCloudFormationStackSetExecutionRole" # do not change this name
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::505982390831:root"
            },
            "Action": "sts:AssumeRole",
            "Condition": {}
        }
    ]
}
EOF
}

// ---------- IAM Policy ----------
resource "aws_iam_policy" "cloudformation-stackset-execution-role-policy" {
  name   = "cloudformation-stackset-execution-role-policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
}
EOF
}

// ---------- Attach Custom IAM Policies ----------
resource "aws_iam_role_policy_attachment" "attach-cloudformation-stackset-execution-role-policy" {
  role       = aws_iam_role.hyoka_AWSCloudFormationStackSetExecutionRole.name
  policy_arn = aws_iam_policy.cloudformation-stackset-execution-role-policy.arn
}


# -----------------------------------------------
# 2. cross-account-cicd-cloudformation-service-role
# -----------------------------------------------

// ---------- IAM Role ----------
resource "aws_iam_role" "hyoka_cross-account-cicd-cloudformation-service-role" {
  name = "cross-account-cicd-cloudformation-service-role"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudformation.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

// ---------- Attach AWS Managed IAM Policies ----------
resource "aws_iam_role_policy_attachment" "attach-AmazonEC2FullAccess" {
  role       = aws_iam_role.hyoka_cross-account-cicd-cloudformation-service-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_role_policy_attachment" "attach-AWSLambda_FullAccess" {
  role       = aws_iam_role.hyoka_cross-account-cicd-cloudformation-service-role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
}


# -----------------------------------------------
# 3. cross-account-cicd-assume-role
# -----------------------------------------------

// ---------- IAM Role ----------
resource "aws_iam_role" "hyoka_cross-account-cicd-assume-role" {
  name = "cross-account-cicd-assume-role"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::505982390831:root"
            },
            "Action": "sts:AssumeRole",
            "Condition": {}
        }
    ]
}
EOF
}

// ---------- IAM Policy ----------
resource "aws_iam_policy" "cicd-cross-account-policy" {
  name   = "cicd-cross-account-policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "cloudformation:*",
                "iam:PassRole"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:Put*",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::hyoka-admin-cicd-artifact-bucket-stg/*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_policy" "cicd-cross-account-policy-kms" {
  name   = "cicd-cross-account-policy-kms"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "kms:DescribeKey",
                "kms:GenerateDataKey*",
                "kms:Encrypt",
                "kms:ReEncrypt*",
                "kms:Decrypt"
            ],
            "Resource": [
                "arn:aws:kms:ap-northeast-1:505982390831:key/c2019952-321a-48f2-9088-76d2ff2a1737"
            ]
        }
    ]
}
EOF
}


// ---------- Attach Custom IAM Policies ----------
resource "aws_iam_role_policy_attachment" "attach-cicd-cross-account-policy" {
  role       = aws_iam_role.hyoka_cross-account-cicd-assume-role.name
  policy_arn = aws_iam_policy.cicd-cross-account-policy.arn
}

resource "aws_iam_role_policy_attachment" "attach-cicd-cross-account-policy-kms" {
  role       = aws_iam_role.hyoka_cross-account-cicd-assume-role.name
  policy_arn = aws_iam_policy.cicd-cross-account-policy-kms.arn
}