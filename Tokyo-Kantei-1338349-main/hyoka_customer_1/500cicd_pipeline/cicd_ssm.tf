# -----------------------------------------------
# Create the following SSM parameters for CICD Pipeline Use
# These parameters are pulled by the SAM template when the CICD Pipeline is run in hyoka_admin 
#
# 1. /{AccountID}/lambda/SGID
# 2. /{AccountID}/lambda/Subnet1A
# 3. /{AccountID}/lambda/Subnet1C
# -----------------------------------------------

######### SSM Paramters ##########

// /{AccountID}/lambda/SGID
resource "aws_ssm_parameter" "lambda_sg_id" {
  name        = "/${var.aws_account_id}/lambda/SGID"
  type        = "String"
  value       = data.terraform_remote_state.base_network.outputs.hyoka_lambda_security_group
  description = "CICDPipeline用情報"
  data_type   = "text"
}

// /{AccountID}/lambda/Subnet1A
resource "aws_ssm_parameter" "lambda_subnet1a" {
  name        = "/${var.aws_account_id}/lambda/Subnet1A"
  type        = "String"
  value       = data.terraform_remote_state.base_network.outputs.private_subnet1
  description = "CICDPipeline用情報"  
  data_type   = "text"
}

// /{AccountID}/lambda/Subnet1C
resource "aws_ssm_parameter" "lambda_subnet1c" {
  name        = "/${var.aws_account_id}/lambda/Subnet1C"
  type        = "String"
  value       = data.terraform_remote_state.base_network.outputs.private_subnet2
  description = "CICDPipeline用情報"
  data_type   = "text"
}