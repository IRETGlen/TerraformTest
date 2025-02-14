terraform {
  required_version = ">= 1.0.0"

  backend "s3" {
    # this key must be unique for each layer!
    bucket  = "286325778687-pipeline-build-state-bucket"
    key     = ".terraform/terraform.dev.400api.tfstate"
    region  = "ap-northeast-1"
    encrypt = "true"
  }
  required_providers {
    aws = "~> 3.0"
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

locals {
}

data "terraform_remote_state" "main_state" {
  backend = "local"

  config = {
    path = "../../_main/terraform.tfstate"
  }
}

data "terraform_remote_state" "pipeline300" {
  backend = "s3"

  config = {
    bucket  = "286325778687-pipeline-build-state-bucket"
    key     = "terraform.development.300pipeline.tfstate"
    region  = "ap-northeast-1"
    encrypt = true
  }
}

data "terraform_remote_state" "pipeline301" {
  backend = "s3"

  config = {
    bucket  = "286325778687-pipeline-build-state-bucket"
    key     = "terraform.development.301pipeline.tfstate"
    region  = "ap-northeast-1"
    encrypt = true
  }
}