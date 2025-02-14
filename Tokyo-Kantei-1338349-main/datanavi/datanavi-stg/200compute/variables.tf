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
variable "function_name" {
  description = "The name of the Lambda Function"
  type        = string  
}

variable "lambda_role_name" {
  description = "The name of the Lambda Role"
  type        = string    
}

variable "logging_policy_name" {
  type = string
  description = "The name of the Lambda Logging Policy"
}
# API Gateway #
variable "api_name" {
  description = "The name of the API"
  type        = string
}

# variable "usage_plan_name" {
#   description = "The name of the usage plan"
#   type        = string  
# }

# S3 Bucket #
variable "bucket_name" {
  description = "The name of the S3 Bucket"
  type        = string  
}