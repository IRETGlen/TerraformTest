/**
 * # 200compute
 */

# pinned provider versions

provider "random" {
  version = "~> 2.0"
}

provider "template" {
  version = "~> 2.0"
}

# default provider
provider "aws" {
  region              = var.region
  #version             = "~> 2.41"
  version             = "~> 4.0" //modified to use terraform modules from hashicorp
  allowed_account_ids = [var.aws_account_id]
}

locals {
  tags = {
    ServiceProvider = "Rackspace"
    Environment     = var.environment
    CostCenter      = var.costcenter
  }
}

data "terraform_remote_state" "base_network" {
  backend = "s3"

  config = {
    bucket  = "864283695195-hyoka-tokyo-build-state-bucket" 
    key     = "terraform.prd.000base.tfstate"
    region  = "ap-northeast-1"
    encrypt = "true"
  }
}
