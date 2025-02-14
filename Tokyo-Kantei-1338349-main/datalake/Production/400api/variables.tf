variable "aws_account_id" {
  description = "The account ID you are building into."
  type        = string
}

variable "region" {
  description = "The AWS region the state should reside in."
  type        = string
}

variable "environment" {
  description = "Environment selection for this build."
  type        = string
}

variable "lambda_stack1" {
  description = "Lambda Function stack name"
  type = string
}

variable "lambda_stack2" {
  description = "Lambda Function stack name"
  type = string
}

variable "api_gateway_name" {
  description = "API Gateway Name"
  type = string
}

variable "api_description" {
  description = "API Gateway"
  type = string
}
