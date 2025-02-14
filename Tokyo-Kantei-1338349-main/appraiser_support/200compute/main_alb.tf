######## Application Load Balancer ########
module "pub-alb" {
  //source                       = "git@github.com:rackspace-infrastructure-automation/aws-terraform-alb//?ref=v0.12.5"
  source                       = "./modules/pub-alb"
  load_balancer_is_internal    = false
  name                         = "${var.app_name_env_code}-pub-alb"
  security_groups              = [data.terraform_remote_state.base_network.outputs.reas_public_alb_security_group]
  subnets                      = data.terraform_remote_state.base_network.outputs.public_subnets
  vpc_id                       = data.terraform_remote_state.base_network.outputs.vpc_id
  environment                  = var.environment
  rackspace_managed            = true
  rackspace_alarms_enabled     = false
  create_logging_bucket        = true
  create_internal_zone_record  = true
  internal_record_name         = "${var.app_name_env_code}-pub-alb.alb."
  internal_zone_id             = data.terraform_remote_state.base_network.outputs.internal_hosted_zone_id
  logging_bucket_force_destroy = true
  logging_bucket_name          = "489746979994-${var.app_name_env_code}-pub-alb-log"
  logging_bucket_retention     = 14
  logging_enabled              = true
  enable_https_redirect        = false
  target_groups_count = 1
  target_groups = [
    {
      "name"                             = "${var.app_name_env_code}-web-tg"
      "backend_protocol"                 = "HTTP"
      "health_check_path"                = "/"
      "backend_port"                     = 80
      "health_check_healthy_threshold"   = 2
      "health_check_unhealthy_threshold" = 10
      "health_check_timeout"             = 60
      "health_check_interval"            = 120
      "health_check_matcher"             = "200,301"
      "deregistration_delay"             = 300
    }
  ]
  target_groups_defaults = [
  {
    "cookie_duration": 86400,
    "deregistration_delay": 300,
    "health_check_healthy_threshold": 2,
    "health_check_interval": 120,
    "health_check_matcher": "200,301",
    "health_check_path": "/",
    "health_check_port": "traffic-port",
    "health_check_timeout": 5,
    "health_check_unhealthy_threshold": 10,
    "load_balancing_algorithm_type": "round_robin",
    "slow_start": 0,
    "stickiness_enabled": false,
    "target_type": "instance"
  }
 ]
  tags               = local.tags
}


###### Listener Rules for Port 443 ######
resource "aws_lb_listener" "fixed-response" {
  load_balancer_arn = "arn:aws:elasticloadbalancing:ap-northeast-1:489746979994:loadbalancer/app/reas-prd-pub-alb/dcbb202434dfbf2a"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  certificate_arn   = var.certificate_arn_tokyo

  default_action {
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = "403"
    }
  }
}

resource "aws_alb_listener_rule" "forward" {
  listener_arn = "arn:aws:elasticloadbalancing:ap-northeast-1:489746979994:listener/app/reas-prd-pub-alb/dcbb202434dfbf2a/1f3d41f7622545e6"

  action {
    target_group_arn = element(module.pub-alb.target_group_arns,0)
    type             = "forward"
  }
  condition{
    path_pattern {
      values = ["*"]
    }
  }
}

###### Register Instances to Target Groups ######
resource "aws_lb_target_group_attachment" "web-80-att0" {
  target_group_arn = element(module.pub-alb.target_group_arns,0)
  target_id        = element(module.web_ar.ar_instance_id_list,0)
  port             = 80
}
