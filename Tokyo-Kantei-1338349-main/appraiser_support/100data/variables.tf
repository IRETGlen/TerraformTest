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

variable "rds_password" {
  description = "RDS Password"
  type        = string
}

variable "rds_engine" {
  description = "RDS engine"
  type        = string
}

variable "rds_engine_version" {
  description = "RDS engine version."
  type        = string
  default     = ""
}

variable "rds_instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "rds_auto_minor_version_upgrade" {
  description = "RDS auto minor version upgrade"
  type        = string
}

variable "rds_rackspace_alarms_enabled" {
  description = "RDS rackspace alarms"
  type        = string
}

variable "rds_internal_record_name" {
  description = "RDS Internal Record Name"
  type        = string
}
