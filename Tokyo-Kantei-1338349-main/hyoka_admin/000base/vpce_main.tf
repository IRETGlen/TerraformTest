module "s3_vpc_endpoint" {
  source                     = "git@github.com:rackspace-infrastructure-automation/aws-terraform-vpc_endpoint?ref=v0.12.5"
  environment                = var.environment
  s3_endpoint_enable         = true
  dynamo_db_endpoint_enable  = false
  vpc_id                     = module.base_network.vpc_id
  tags = {
    ServiceProvider = "Rackspace"
    Environment     = var.environment
    CostCenter      = var.costcenter
    Name            = "${var.app_name_env_code}-${var.s3_vpce_name}" 
  }
  route_tables = concat(
    module.base_network.private_route_tables,
  )
}


module "appstream_vpc_endpoint" {
  source                     = "git@github.com:rackspace-infrastructure-automation/aws-terraform-vpc_endpoint?ref=v0.12.5"
  environment                = var.environment
  s3_endpoint_enable         = false
  dynamo_db_endpoint_enable  = false
  interface_endpoints       = ["appstream.streaming"]
  enable_private_dns_list   = ["appstream.streaming"]
  security_groups           = [aws_security_group.hyoka_admin_appstream_endpoint_security_group.id]
  subnets                    = module.base_network.private_subnets
  vpc_id                     = module.base_network.vpc_id
  tags = {
    ServiceProvider = "Rackspace"
    Environment     = var.environment
    CostCenter      = var.costcenter
    Name            = "${var.app_name_env_code}-${var.appstream_vpce_name}" 
  }
  route_tables = concat(
    module.base_network.private_route_tables,
  )
}


module "apigw_vpc_endpoint" {
  source                     = "git@github.com:rackspace-infrastructure-automation/aws-terraform-vpc_endpoint?ref=v0.12.5"
  environment                = var.environment
  s3_endpoint_enable         = false
  dynamo_db_endpoint_enable  = false
  interface_endpoints       = ["execute-api"]
  enable_private_dns_list   = ["execute-api"]
  security_groups           = [aws_security_group.hyoka_admin_apigw_endpoint_security_group.id]
  subnets                    = module.base_network.public_subnets
  vpc_id                     = module.base_network.vpc_id
  tags = {
    ServiceProvider = "Rackspace"
    Environment     = var.environment
    CostCenter      = var.costcenter
    Name            = "${var.app_name_env_code}-${var.apigw_vpce_name}" 
  }
  route_tables = concat(
    module.base_network.public_route_tables,
  )
}
