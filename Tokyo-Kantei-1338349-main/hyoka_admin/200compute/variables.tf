# Environment #
variable "aws_account_id" {
  description = "The account ID you are building into."
  type        = string
}

variable "region" {
  description = "The AWS region the state should reside in."
  type        = string
}

variable "environment" {
  description = "The name of the environment, e.g. Production, Development, etc."
  type        = string
}

variable "costcenter" {
  description = "Customer Name"
  type        = string
}

variable "app_name" {
  description = "Name of the application"
  type        = string
}

variable "app_env" {
  description = "Short environment variable, e.g. Dev, Prod, Test"
  default     = "Dev"
}

variable "app_name_env_code" {
  description = "The name of the application,environment,location."
  type        = string
}

# Lambda #
variable "function_names_group_1" {
  description = "Function Names"
  type        = set(string)
}

variable "function_names_group_2" {
  description = "Function Names"
  type        = set(string)
}

variable "function_names_group_3" {
  description = "Function Setting for Group 3"
  type        = map
}

variable "cwloggroup_retention_7days" {
  description = "CW log group for 7 days retention"
  type        = set(string)
}

variable "cwloggroup_retention_neverexpire" {
  description = "CW log group for never expire retention"
  type        = set(string)
}

variable "lambda_post_permission_group_system_api" {
  description = "Post Permissions for System API"
  type        = set(string)
}

variable "lambda_get_permission_group_system_api" {
  description = "Get Permissions for System API"
  type        = set(string)
}

variable "iam_role_lambda" {
  description = "The name of the Lambda Role"
  type        = string    
}

variable "iam_role_shusys_step_lambda" {
  description = "The name of the Lambda Role"
  type        = string    
}

variable "iam_role_get_csv_url" {
  description = "The name of the Lambda Role"
  type        = string    
}

variable "iam_role_shusys_api_lambda" {
  description = "The name of the Lambda Role"
  type        = string    
}

variable "iam_role_api_stepfunctions" {
  description = "The name of the Lambda Role"
  type        = string    
}

variable "iam_user" {
  description = "The name of the IAM User"
  type        = string    
}

# variable "logging_policy_name" {
#   type = string
#   description = "The name of the Lambda Logging Policy"
# }

# API Gateway #
variable "system_api_name" {
  description = "The name of the API"
  type        = string
}

variable "link_api_name" {
  description = "The name of the API"
  type        = string
}

# # variable "usage_plan_name" {
# #   description = "The name of the usage plan"
# #   type        = string  
# # }

# # S3 Bucket #
# variable "bucket_name" {
#   description = "The name of the S3 Bucket"
#   type        = string  
# }