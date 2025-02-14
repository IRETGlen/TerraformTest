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


# # AppStream #
# variable "image_arn" {
#   description = "The ARN of the appstream image name."
#   type        = string
# }

# variable "fleet_name" {
#   description = "The name of the appsteam fleet."
#   type        = string
# }

# variable "fleet_type" {
#   description = "The type of the appsteam fleet."
#   type        = string
# }

# variable "minimum_capacity" {
#   description = "The minimum capacity of the appstream fleet."
#   type        = number
# }

# variable "maximum_capacity" {
#   description = "The maximum capacity of the appstream fleet."
#   type        = number
# }

# variable "desired_capacity" {
#   description = "The desired capacity of the appstream fleet."
#   type        = number
# }

# variable "appstream_instance_type" {
#   description = "The desired capacity of the appstream fleet."
#   type        = string
# }

# variable "appstream_subnet_ids" {
#   description = "The desired capacity of the appstream fleet."
#   type        = list(string)
# }

# variable "appstream_fleet_sgs" {
#   description = "The desired capacity of the appstream fleet."
#   type        = list(string)
# }

# variable "stack_name" {
#   description = "The name of the appsteam stack."
#   type        = string
# }

# variable "cognito_userpool_name" {
#   description = "The name of the cognito userpool."
#   type        = string
# }

variable "cognito_userpool_arn" {
  description = "The arn of the cognito userpool."
  type        = string
}