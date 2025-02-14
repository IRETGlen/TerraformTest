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

##### RDS #####
variable "rds_name" {
  description = "RDS Instance Name"
  type        = string
}

variable "rds_engine" {
  description = "RDS engine"
  type        = string
}

variable "rds_engine_mode" {
  description = "RDS engine mode"
  type        = string
}

variable "rds_engine_version" {
  description = "RDS engine version."
  type        = string
  default     = ""
}

# variable "rds_security_group_ids" {
#   description = "RDS security group ids"
#   type        = list(string)
# }

variable "rds_subnet_group_name" {
  description = "RDS subnet group name"
  type        = string
}

# variable "rds_subnet_ids" {
#   description = "subnet IDs for RDS subnet group"
#   type        = list(string)
# }

variable "rds_instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "rds_cluster_parameter_group_name" {
  description = "RDS cluster parameter group name"
  type        = string
}

variable "rds_cluster_parameter_family" {
  description = "RDS cluster parameter family"
  type        = string
}

variable "rds_snapshot_id" {
  description = "RDS Snapshot ID"
  type        = string
}