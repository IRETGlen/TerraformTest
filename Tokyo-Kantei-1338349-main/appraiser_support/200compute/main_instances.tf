######################### WEB ####################
module "web_ar" {
  source                     = "git@github.com:rackspace-infrastructure-automation/aws-terraform-ec2_autorecovery//?ref=v0.12.18"
  ec2_os                     = var.ec2_os
  subnets                    = [data.terraform_remote_state.base_network.outputs.web_private_subnet1]
  name                       = var.ar_resource_name
  security_groups            = [data.terraform_remote_state.base_network.outputs.reas_web_security_group]
  key_pair                   = var.internal_key_pair
  instance_type              = "t3.large"
  primary_ebs_volume_size    = "30"
  instance_count             = "1"
  rackspace_managed          = true
  backup_tag_value           = "True"
  tags                       = local.tags
  image_id                   = var.ubuntu_imageid
  enable_recovery_alarms     = true
  encrypt_primary_ebs_volume = true
  ebs_volume_tags = {
    Name = var.ar_resource_name
  }
}
