/**
 * # 300other
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
  version             = "~> 2.41"
  #version             = "~> 4.0"
  allowed_account_ids = [var.aws_account_id]
}

locals {
  tags = {
    ServiceProvider = "Rackspace"
    Environment     = var.environment
    CostCenter      = var.costcenter
  }
}

# terraform block cannot be interpolated; sample provided as output of _main
terraform {
  required_version = ">= 0.12"
  backend "s3" {
    # this key must be unique for each layer!
    bucket  = "126791008945-datanavi-dev-tokyo-build-state-bucket"
    key     = "terraform.dev.300other.tfstate"
    region  = "ap-northeast-1"
    encrypt = "true"
  }
}

data "terraform_remote_state" "base_network" {
  backend = "s3"

  config = {
    bucket  = "126791008945-datanavi-dev-tokyo-build-state-bucket"
    key     = "terraform.dev.000base.tfstate"
    region  = "ap-northeast-1"
    encrypt = "true"
  }
}
