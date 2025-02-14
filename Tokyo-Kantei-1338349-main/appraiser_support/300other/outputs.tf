output "state_import_example" {
  description = "An example to use this layers state in another."

  value = <<EOF


  data "terraform_remote_state" "300other." {
    backend = "s3"

    config = {
      bucket  = "489746979994-reas-prd-tokyo-build-state-bucket"
      key     = "terraform.${lower(var.environment)}.200compute.tfstate"
      region  = "ap-northeast-1"
    }
  }
EOF
}

###############################################################################
# Summary Output
# terraform output summary
###############################################################################
output "summary" {
  value = <<EOF

## Outputs - 300other layer

| Distribution ARN | Domain Name | Hosted Zone ID |
|---|---|---|
| ${module.cloudfront_custom_origin.arn} | ${module.cloudfront_custom_origin.domain_name} | ${module.cloudfront_custom_origin.hosted_zone_id}


EOF

  description = "Other Layer Outputs Summary `terraform output summary` "
}
