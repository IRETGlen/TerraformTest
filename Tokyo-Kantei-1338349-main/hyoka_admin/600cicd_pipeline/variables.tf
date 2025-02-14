#### Environment ####
variable "aws_account_id" {
  description = "The account ID you are building into."
  type        = string
}

variable "environment" {
  description = "Environment selection for this build."
  type        = string
}

variable "region" {
  description = "The AWS region the state should reside in."
  type        = string
}

variable "app_name_env_code" {
  description = "The environment code"
  type        = string
}

#### Resources ####
variable "vpc_id" {
  description = "VPC for Deploy"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets"
  type        = list
}

variable "security_group_ids" {
  description = "Security Group List"
  type        = list
}

variable "SNSContact" {
  description = "SNS Technical Contact"
  type        = string
}

variable "devadmin_email" {
  description = "SNS Technical Contact"
  type        = string
}

variable "cloudformation_stack_name" {
  description = "Cloudformation stack name."
  type        = string
}

#### IAM Roles ####
variable "eventbridge_iam_role" {
  description = "IAM Role name for Event Bridge"
  type        = string
}

variable "cloudformation_iam_role" {
  description = "IAM Role name for CloudFormation"
  type        = string
}

variable "codepipeline_iam_role" {
  description = "IAM Role name for CodePipeline"
  type        = string
}

variable "codesource_iam_role" {
  description = "IAM Role name for CodeSource"
  type        = string
}

variable "codebuild_iam_role" {
  description = "IAM Role name for CodeSource"
  type        = string
}


#### Pipeline Stg ####
variable "stg_pipeline_name" {
  description ="Specify the pipeline name for deployment"
  type = string
}

variable "stg_artifact_bucket_name" {
  description = "Bucket name for stg pipeline artifact"
  type        = string
}

variable "stg_codebuild_project_name" {
  description = "CodeBuild project name for stg pipeline"
  type        = string
}


#### Pipeline Prd ####
variable "prd_pipeline_name" {
  description ="Specify the pipeline name for deployment"
  type = string
}

variable "prd_artifact_bucket_name" {
  description = "Bucket name for prd pipeline artifact"
  type        = string
}

variable "prd_codebuild_project_name" {
  description = "CodeBuild project name for prd pipeline"
  type        = string
}


#### Pipeline Both ####
variable "commit_respository_name" {
  description = "Commit repo name."
  type        = string
}

variable "sns_topic_name" {
  description = "SNS Topic Name"
  type        = string
}

variable "lambda_name" {
  description = "Lambda Name"
  type        = string
}


# Test Resources 
variable "cross_account_ids" {
  description = "cross_account_ids"
  type        = list
}

# Lambda Permissions
variable "lambda_post_permission_group_system_api" {
  description = "Post Permissions for System API"
  type        = set(string)
}

variable "lambda_get_permission_group_system_api" {
  description = "Get Permissions for System API"
  type        = set(string)
}

variable "system_api_arn" {
  description = "SYSTEM API ARN"
  type        = string
}

variable "link_api_arn" {
  description = "LINK API ARN"
  type        = string
}