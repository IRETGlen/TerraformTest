# output "state_import_example" {
#   description = "An example to use this layers state in another."

#   value = <<EOF


#   data "terraform_remote_state" "200compute." {
#     backend = "s3"

#     config = {
#       bucket  = "126791008945-datanavi-prd-tokyo-build-state-bucket"
#       key     = "terraform.${lower(var.environment)}.200compute.tfstate"
#       region  = "ap-northeast-1"
#     }
#   }
# EOF
# }

# ###############################################################################
# # Summary Output
# # terraform output summary
# ###############################################################################
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
