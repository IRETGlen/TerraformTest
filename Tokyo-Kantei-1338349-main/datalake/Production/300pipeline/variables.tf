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

variable "commit_respository_name" {
  description = "Commit repo name."
  type        = string
}

variable "pipeline_name" {
  description ="Specify the pipeline name for deployment"
  type = string
}

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

variable "cloudformation_stack_name" {
  description = "Cloudformation stack name."
  type        = string
}

variable "apigateway_execution_url" {
  description = "API GW Execution URL." # "${aws_api_gateway_rest_api.api.id}.execute-api.ap-northeast-1.amazonaws.com"
  type        = string
}