output "state_import_example" {
  description = "An example to use this layers state in another."

  value = <<EOF


  data "terraform_remote_state" "200compute." {
    backend = "s3"

    config = {
      bucket  = "864283695195-hyoka-tokyo-build-state-bucket"
      key     = "terraform.${lower(var.environment)}.200compute.tfstate"
      region  = "ap-northeast-1"
    }
  }
EOF
}


###############################################################################
# IAM Roles Output
###############################################################################
output "hyoka_shusys_step_lambda_role" {
  value       = aws_iam_role.hyoka_shusys_step_lambda_role.arn
  description = "IAM Role for Step Funcitons"
}

###############################################################################
# Summary Output
# terraform output summary
###############################################################################
# output "summary" {
#   value = <<EOF

# ## Outputs - 200compute layer

# | Lambda ARN                                                           | IAM Role               | 
# |----------------------------------------------------------------------|------------------------|
# | ${aws_lambda_function.pastmap_lambda.arn} | ${var.lambda_role_name} |

# | API Name        | API ID      | Resource ID | IAM Role       |
# |-----------------|-------------|-------------|----------------|
# | ${var.api_name} | ${aws_api_gateway_rest_api.pastmap_api.id}  | ${aws_api_gateway_rest_api.pastmap_api.root_resource_id}  | APIGatewayRole |


# EOF

#   description = "Other Layer Outputs Summary `terraform output summary` "
# }
