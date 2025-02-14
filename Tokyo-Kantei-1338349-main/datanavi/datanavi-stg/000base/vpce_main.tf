module "vpc_endpoint" {
  source                     = "git@github.com:rackspace-infrastructure-automation/aws-terraform-vpc_endpoint?ref=v0.12.5"
  environment                = var.environment
  s3_endpoint_enable         = true
  dynamo_db_endpoint_enable  = false
  subnets                    = module.base_network.private_subnets
  vpc_id                     = module.base_network.vpc_id
  tags = {
    ServiceProvider = "Rackspace"
    Environment     = var.environment
    CostCenter      = var.costcenter
    Name            = var.vpce_name
  }
  route_tables = concat(
    module.base_network.private_route_tables,
  )
}