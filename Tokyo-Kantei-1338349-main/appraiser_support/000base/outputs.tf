###############################################################################
# State Import Example
# terraform output state_import_example
###############################################################################
output "state_import_example" {
  description = "An example to use this layers state in another."

  value = <<EOF
  data "terraform_remote_state" "base_network" {
    backend = "s3"
    config = {
      bucket  = "${data.terraform_remote_state.main_state.outputs.state_bucket_id}"
      key     = "terraform.${lower(var.app_env)}.000base.tfstate"
      region  = "${data.terraform_remote_state.main_state.outputs.state_bucket_region}"
      encrypt = "true"
    }
  }
EOF
}

output "vpc_id" {
  description = "The VPC ID of the Base Network."
  value       = module.base_network.vpc_id
}

###############################################################################
# Base Network Output
###############################################################################

output "nat_gateway_eip" {
  description = "The NAT gateway EIP(s) of the Base Network."
  value       = module.base_network.nat_gateway_eip
}

output "private_route_tables" {
  description = "The private route tables of the Base Network."
  value       = module.base_network.private_route_tables
}

output "private_subnets" {
  description = "The private subnets of the Base Network."
  value       = module.base_network.private_subnets
}

output "web_private_subnet1" {
  description = "The private Web subnet 1 of the Base Network."
  value       = "${element(module.base_network.private_subnets,0)}"
}

output "web_private_subnet2" {
  description = "The private Web subnet 1 of the Base Network."
  value       = "${element(module.base_network.private_subnets,1)}"
}

output "db_private_subnet1" {
  description = "The private DB subnet 1 of the Base Network."
  value       = "${element(module.base_network.private_subnets,2)}"
}

output "db_private_subnet2" {
  description = "The private DB subnet 1 of the Base Network."
  value       = "${element(module.base_network.private_subnets,3)}"
}

output "public_route_tables" {
  description = "The public route tables of the Base Network."
  value       = module.base_network.public_route_tables
}

output "public_subnets" {
  description = "The public subnets of the Base Network."
  value       = module.base_network.public_subnets
}


###############################################################################
# Security Groups Output
###############################################################################
output "reas_public_alb_security_group" {
  value       = aws_security_group.reas_public_alb_security_group.id
  description = "Public ALB Security Group"
}

output "reas_web_security_group" {
  value       = aws_security_group.reas_web_security_group.id
  description = "Web Security Group"
}

output "reas_rds_security_group" {
  value       = aws_security_group.reas_rds_security_group.id
  description = "RDS Security Group"
}

###############################################################################
# SNS Output
###############################################################################
output "sns_topic" {
  description = "SNS Topic"
  value       = module.sns_topic
}

###############################################################################
# DNS Output
###############################################################################

output "internal_hosted_zone_id" {
  description = "Route 53 Internal Hosted Zone ID."
  value       = module.internal_zone.internal_hosted_zone_id
}

output "internal_hosted_zone_name" {
  description = "Route 53 Internal Hosted Zone Name."
  value       = module.internal_zone.internal_hosted_name
}

###############################################################################
# Summary Output
# terraform output summary
###############################################################################

output "summary" {
  value = <<EOF

  ## Subnets
 
  | Subnet Name | Subnet ID |
  |----------------------------------------------|--------------------------|
  | ${var.app_name_env_code}-${element(var.public_subnet_names,0)}1  | ${element(module.base_network.public_subnets,0)} |
  | ${var.app_name_env_code}-${element(var.public_subnet_names,1)}1  | ${element(module.base_network.public_subnets,1)} |
  | ${var.app_name_env_code}-${element(var.private_subnet_names,0)}1 | ${element(module.base_network.private_subnets,0)} |
  | ${var.app_name_env_code}-${element(var.private_subnet_names,1)}1 | ${element(module.base_network.private_subnets,1)} |
  | ${var.app_name_env_code}-${element(var.private_subnet_names,2)}1 | ${element(module.base_network.private_subnets,2)} |
  | ${var.app_name_env_code}-${element(var.private_subnet_names,3)}1 | ${element(module.base_network.private_subnets,3)} |


  ## Security Groups
  | SecurityGroup Name | SecurityGroup ID|
  |----------------------------------|----------------------|
  | ${var.app_name_env_code}-public-alb-SG | ${aws_security_group.reas_public_alb_security_group.id} |
  | ${var.app_name_env_code}-web-SG | ${aws_security_group.reas_web_security_group.id} |
  | ${var.app_name_env_code}-rds-SG | ${aws_security_group.reas_rds_security_group.id} |

  EOF
    description = "Base Network Layer Outputs Summary `terraform output summary` "
}