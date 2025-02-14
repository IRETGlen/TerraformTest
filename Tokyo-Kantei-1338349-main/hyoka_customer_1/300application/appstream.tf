# -----------------------------------------------
# --- AppStream Fleet
# --- AppStream Fleet Autoscaling
# --- AppStream Stack
# --- AppStream Fleet/Stack Association
# -----------------------------------------------

# -----------------------------------------------
# AppStream Fleet
# -----------------------------------------------
resource "aws_appstream_fleet" "hyoka_appstream_fleet" {
  name                               = var.fleet_name
  display_name                       = var.fleet_name
  enable_default_internet_access     = true
  fleet_type                         = var.fleet_type
  image_arn                          = var.image_arn
  instance_type                      = var.appstream_instance_type
  max_user_duration_in_seconds       = 57600
  disconnect_timeout_in_seconds      = 7200

  compute_capacity {
    desired_instances = 1
  }

  vpc_config {
    subnet_ids         = data.terraform_remote_state.base_network.outputs.public_subnets
    security_group_ids = [data.terraform_remote_state.base_network.outputs.hyoka_appstream_image_security_group]
  }

  tags = {
    Environment      = var.environment
    ServiceProvider  = "Rackspace"
  }
}

# -----------------------------------------------
# AppStream Fleet Autoscaling
# -----------------------------------------------
# Autoscaling is configured manually from the console

# -----------------------------------------------
# AppStream Stack
# -----------------------------------------------
resource "aws_appstream_stack" "hyoka_appstream_stack" {
  name         = var.stack_name
  display_name = var.stack_name

  storage_connectors {
    connector_type = "HOMEFOLDERS"
  }

  application_settings {
    enabled        = true
    settings_group = "shusys"
  }

  user_settings {
    action     = "CLIPBOARD_COPY_FROM_LOCAL_DEVICE"
    permission = "ENABLED"
  }
  user_settings {
    action     = "CLIPBOARD_COPY_TO_LOCAL_DEVICE"
    permission = "ENABLED"
  }
  user_settings {
    action     = "DOMAIN_PASSWORD_SIGNIN"
    permission = "ENABLED"
  }
  user_settings {
    action     = "DOMAIN_SMART_CARD_SIGNIN"
    permission = "DISABLED"
  }
  user_settings {
    action     = "FILE_DOWNLOAD"
    permission = "ENABLED"
  }
  user_settings {
    action     = "FILE_UPLOAD"
    permission = "ENABLED"
  }
  user_settings {
    action     = "PRINTING_TO_LOCAL_DEVICE"
    permission = "ENABLED"
  }

  tags = {
    Environment      = var.environment
    ServiceProvider  = "Rackspace"
  }
}

# -----------------------------------------------
# AppStream Fleet/Stack Association
# -----------------------------------------------
resource "aws_appstream_fleet_stack_association" "hyoka_fleet_stack_association" {
  fleet_name = aws_appstream_fleet.hyoka_appstream_fleet.name
  stack_name = aws_appstream_stack.hyoka_appstream_stack.name
}
