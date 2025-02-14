# output "state_import_example" {
#   description = "An example to use this layers state in another."

#   value = <<EOF


#   data "terraform_remote_state" "100data." {
#     backend = "s3"

#     config = {
#       bucket  = "505982390831-hyoka-tokyo-build-state-bucket"
#       key     = "terraform.${lower(var.environment)}.100data.tfstate"
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

# ## Outputs - 100data layer

# | RDS Name | Endpoint | IAM Role | 
# |---|---|---|
# | ${module.rds.db_instance} | ${module.rds.db_endpoint} | ${module.rds.monitoring_role} |


# EOF

#   description = "Data Layer Outputs Summary `terraform output summary` "
# }
