###############################################################################
# Variables - Environment
###############################################################################
variable "aws_account_id" {
  description = "AWS Account ID"
}

variable "region" {
  description = "Default Region"
  default     = "ap-southeast-1"
}

variable "environment" {
  description = "Name of the environment for the deployment, e.g. Integration, PreProduction, Production, QA, Staging, Test"
  default     = "Development"
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

###############################################################################
# Variables - Base Network
###############################################################################

variable "vpc_name" {
  description = "Name for the VPC	"
  default     = "BaseNetwork"
}

variable "cidr_range" {
  description = "CIDR range for the VPC"
}

variable "azs" {
  description = "A list of AZs that VPC resources will reside in"
  type        = list(string)
}

variable "az_count" {
  description = "Number of AZs to utilize for the subnets"
  type        = number
}

variable "private_cidr_ranges" {
  description = "An array of CIDR ranges to use for private subnets"
  type        = list(string)
}

variable "private_subnet_names" {
  description = "An array of Names for CIDR ranges to use for private subnets"
  type        = list(string)
}

variable "public_cidr_ranges" {
  description = "An array of CIDR ranges to use for public subnets"
  type        = list(string)
}

variable "public_subnet_names" {
  description = "An array of Names for CIDR ranges to use for public subnets"
  type        = list(string)
}

variable "private_subnets_per_az" {
  description = "Number of private subnets to create in each AZ"
  type        = number
}

variable "public_subnets_per_az" {
  description = "Number of public subnets to create in each AZ"
  type        = number
}

variable "tokyo_kantei_cidr" {
  description = "Tokyo Kantei IP"
  type        = list(string)
}

variable "iij_cidr" {
  description = "IIJ IP"
  type        = list(string)
}

# VPC Endpoints
variable "apigw_vpce_name" {
  description = "The name of the VPC Endpoint for API Gateway"
  type        = string
}

variable "s3_vpce_interface_name" {
  description = "The name of the VPC Interface Endpoint for S3"
  type        = string
}

variable "s3_vpce_gateway_name" {
  description = "The name of the VPC Gateway Endpoint for S3"
  type        = string
}