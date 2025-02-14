######### SSM Paramters ##########

// SECRET_MANAGER_ARN
resource "aws_ssm_parameter" "secret_manager_arn" {
  name        = "SECRET_MANAGER_ARN"
  type        = "SecureString"
  value       = "replace_value"
  description = "シークレットマネージャのARN情報"
  key_id      = "alias/aws/ssm"
  data_type   = "text"
}

// CSV_SET_SHUEKI_PATH
resource "aws_ssm_parameter" "csv_set_shukei_path" {
  name        = "CSV_SET_SHUEKI_PATH"
  type        = "StringList"
  value       = "replace_value"
  description = "収益評価指定項目設定"  
  data_type   = "text"
}

// CSV_SET_YOSOKU_PATH
resource "aws_ssm_parameter" "csv_set_yosoku_path" {
  name        = "CSV_SET_YOSOKU_PATH"
  type        = "StringList"
  value       = "replace_value"
  description = "賃料予測指定項目設定"
  data_type   = "text"
}

// SHU_DB_NAME
resource "aws_ssm_parameter" "shu_db_name" {
  name        = "SHU_DB_NAME"
  type        = "SecureString"
  value       = "replace_value"
  description = "収益評価顧客別DBで利用するDB名"
  key_id      = "alias/aws/ssm"
  data_type   = "text"  
}

// CSV_OUTPUT_ARN
resource "aws_ssm_parameter" "csv_output_arn" {
  name        = "CSV_OUTPUT_ARN"
  type        = "SecureString"
  value       = "replace_value"
  description = "CSV出力先ARN情報"
  key_id      = "alias/aws/ssm"
  data_type   = "text"    
}