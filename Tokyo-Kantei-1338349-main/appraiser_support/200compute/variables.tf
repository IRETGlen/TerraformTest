######## Environment ########
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


######## EC2 ########
variable "ubuntu_imageid" {
  description = "Ubuntu AMI ID"
  type        = string
}

variable "ec2_os" {
  description = "EC2 OS"
  type        = string
}

variable "ar_resource_name" {
  type        = string
  description = "Resource name of Autorecovery instance"
}

variable "internal_key_pair" {
  description = "key pair for internal ec2 resources"
  type        = string
}

variable "web_instances_number" {
  description = "Web instance numbers"
  default = 1
}

###### Load Balancer ######
variable "certificate_arn_tokyo" {
  description = "SSL Certificate for Load Balancer"
  type        = string
}
