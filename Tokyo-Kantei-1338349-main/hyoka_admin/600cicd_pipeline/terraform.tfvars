# Environment
aws_account_id    = "505982390831"
environment       = "staging"
region            = "ap-northeast-1"
app_name_env_code = "hyoka-admin"


# Resources
commit_respository_name   = "hyoka-admin-cicd-codecommit-repo"
cloudformation_stack_name = "hyoka-admin-lambda-stack"
vpc_id                    = "vpc-0c05881c38ed07084"
subnet_ids                = ["subnet-069a84c078820d855","subnet-06852bf487a9374ba"]
security_group_ids        = ["sg-0002241c683b5452c"]


# SNS Notification
SNSContact     = "rika.chinen@rackspace.com"
devadmin_email = "rika.chinen@rackspace.com" 
sns_topic_name = "hyoka-admin-cicd-sns-topic"


# IAM Roles
eventbridge_iam_role    = "cicd-eventbridge-iam-role"
cloudformation_iam_role = "cicd-cloudformation-iam-role"
codepipeline_iam_role   = "cicd-codepipeline-iam-role"
codesource_iam_role     = "cicd-codesource-iam-role"
codebuild_iam_role      = "cicd-codebuild-iam-role"


# Staging Pipeline
stg_artifact_bucket_name   = "505982390831-hyoka-admin-cicd-artifact-bucket-stg"
stg_pipeline_name          = "hyoka-admin-cicd-pipeline-stg"
stg_codebuild_project_name = "hyoka-admin-cicd-codebuild-stg"


# Production Pipeline
prd_artifact_bucket_name   = "505982390831-hyoka-admin-cicd-artifact-bucket-prd"
prd_pipeline_name          = "hyoka-admin-cicd-pipeline-prd"
prd_codebuild_project_name = "hyoka-admin-cicd-codebuild-prd"


# Lambda
lambda_name = "HyokaCreatePullRequest"

# Test Resources 
cross_account_ids = ["195671766185"]


# Lambda Permissions

system_api_arn = "arn:aws:execute-api:ap-northeast-1:505982390831:3qct3xsh67"
link_api_arn   = "arn:aws:execute-api:ap-northeast-1:505982390831:7z4i6t524j"

lambda_post_permission_group_system_api = [
  "GetTkyd",
  "GetTksd",
  "StoreTkyd",
  "StoreTksd",
  "DeleteBuild",
  "ActionRenkeiKeyEditFreeKey",
  "ActionRenkeiKeyEditRenkeiKey",
  "ActionRenkeiKeyDeleteBuild",
  "CreateCsv",
  "CheckLoadRenkeiKey",
  "CheckEditKey",
  "EditRenkeiKey",
  "EditFreeKey",
  "GetHistoryProspect",
  "GetHistoryAssessment",
  "ReviveBuild",
  "StartGetListCsv"
]

lambda_get_permission_group_system_api = [
  "GetTkyd",
  "GetTksd"
]