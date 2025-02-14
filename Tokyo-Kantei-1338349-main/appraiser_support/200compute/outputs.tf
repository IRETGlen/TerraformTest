output "state_import_example" {
  description = "An example to use this layers state in another."

  value = <<EOF


  data "terraform_remote_state" "200compute." {
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

## Outputs - 200compute layer

| Instance Name | Instance ID | Private IP | Image ID |
|---|---|---|
| ${var.ar_resource_name}   | ${element(module.web_ar.ar_instance_id_list,0)} | ${element(module.web_ar.ar_instance_ip_list,0)}  | ${module.web_ar.ar_image_id} | 


| ALB Name | DNS Name |
|---|---|
| ${var.app_name_env_code}-pub-alb | ${module.pub-alb.alb_dns_name} |

EOF

  description = "Compute Layer Outputs Summary `terraform output summary` "
}

###############################################################################
# Compute Layer Output
###############################################################################
output "alb_dns_name" {
  description = "The private subnets of the Base Network."
  value       = module.pub-alb.alb_dns_name
}