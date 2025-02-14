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