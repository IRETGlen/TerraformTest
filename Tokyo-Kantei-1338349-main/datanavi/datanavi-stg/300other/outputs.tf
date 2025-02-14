output "state_import_example" {
  description = "An example to use this layers state in another."

  value = <<EOF


  data "terraform_remote_state" "300other." {
    backend = "s3"

    config = {
      bucket  = "126791008945-datanavi-stg-tokyo-build-state-bucket"
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

| 5XX Alarm ID | 4XX Alarm ID | IntegrationLatency Alarm ID |
|---|---|---|
| ${module.alarm_5XX.alarm_id[0]} | ${module.alarm_4XX.alarm_id[0]} | ${module.alarm_integrationlatency.alarm_id[0]} |


EOF

  description = "Other Layer Outputs Summary `terraform output summary` "
}
