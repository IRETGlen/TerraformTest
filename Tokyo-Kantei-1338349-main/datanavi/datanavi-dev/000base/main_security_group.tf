##### Lambda Security Group ######
resource "aws_security_group" "datanavi_dev_lambda_security_group" {
  name_prefix            = "${var.app_name_env_code}-pastmap-lambda-sg"
  description            = "Lambda Security Group"
  vpc_id                 = module.base_network.vpc_id
  revoke_rules_on_delete = true

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.tags, map("Name", "${var.app_env}-pastmap-lambda-sg"))
}

resource "aws_security_group_rule" "datanavi_dev_lambda_all_egress" {
  type              = "egress"
  security_group_id = aws_security_group.datanavi_dev_lambda_security_group.id
  description       = "To NATGW"
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}
