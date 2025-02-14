terraform {
  required_version = ">= 1.0.0"

  backend "s3" {
    # this key must be unique for each layer!
    bucket  = "864283695195-hyoka-tokyo-build-state-bucket"
    key     = "terraform.prd.500cicd_pipeline.tfstate"
    region  = "ap-northeast-1"
    encrypt = true
  }

  required_providers {
    aws = "~> 4.4"
    random = "~> 2.0"
    template = "~> 2.0"
  }
}

# pinned provider versions

provider "aws" {
  region              = var.region
  allowed_account_ids = [var.aws_account_id]
}

data "aws_caller_identity" "current" {}

data "terraform_remote_state" "main_state" {
  backend = "local"

  config = {
    path = "../_main/terraform.tfstate"
  }
}


locals {
  tags = {
    Environment     = var.environment
    ServiceProvider = "Rackspace"
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