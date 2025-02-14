###### Public ALB Security Group ######
resource "aws_security_group" "reas_public_alb_security_group" {
  name_prefix            = "${var.app_name_env_code}-public-alb-SG"
  description            = "Public ALB Security Group"
  vpc_id                 = module.base_network.vpc_id
  revoke_rules_on_delete = true

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.tags, map("Name", "${var.app_name_env_code}-public-alb-SG"))
}

resource "aws_security_group_rule" "reas_public_alb_http_ingress" {
  type              = "ingress"
  description       = "From CloudFront"
  security_group_id = aws_security_group.reas_public_alb_security_group.id
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "reas_public_alb_https_ingress" {
  type              = "ingress"
  description       = "From CloudFront"
  security_group_id = aws_security_group.reas_public_alb_security_group.id
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "reas_public_alb_http_egress" {
  type              = "egress"
  security_group_id = aws_security_group.reas_public_alb_security_group.id
  description       = "To Web Server"
  to_port           = 80
  from_port         = 80
  protocol          = "tcp"
  source_security_group_id = aws_security_group.reas_web_security_group.id
}


###### Web Security Group ######
resource "aws_security_group" "reas_web_security_group" {
  name_prefix            = "${var.app_name_env_code}-web-SG"
  description            = "Web Security Group"
  vpc_id                 = module.base_network.vpc_id
  revoke_rules_on_delete = true

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.tags, map("Name", "${var.app_name_env_code}-web-SG"))
}

resource "aws_security_group_rule" "reas_web_http_ingress" {
  type              = "ingress"
  description       = "From ALB"
  security_group_id = aws_security_group.reas_web_security_group.id
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = aws_security_group.reas_public_alb_security_group.id
}

resource "aws_security_group_rule" "reas_web_https_egress" {
  type              = "egress"
  description       = "To Internet"
  security_group_id = aws_security_group.reas_web_security_group.id
  to_port           = 443
  from_port         = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "reas_web_http_egress" {
  type              = "egress"
  description       = "To Internet"
  security_group_id = aws_security_group.reas_web_security_group.id
  to_port           = 80
  from_port         = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "reas_web_database_egress" {
  type              = "egress"
  description       = "To Database"
  security_group_id = aws_security_group.reas_web_security_group.id
  to_port           = 5432
  from_port         = 5432
  protocol          = "tcp"
  source_security_group_id = aws_security_group.reas_rds_security_group.id
}


###### RDS Security Group ######
resource "aws_security_group" "reas_rds_security_group" {
  name_prefix            = "${var.app_name_env_code}-rds-SG"
  description            = "RDS Group"
  vpc_id                 = module.base_network.vpc_id
  revoke_rules_on_delete = true

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.tags, map("Name", "${var.app_name_env_code}-rds-SG"))
}

resource "aws_security_group_rule" "reas_rds_web_ingress" {
  type              = "ingress"
  description       = "From Web Server"
  security_group_id = aws_security_group.reas_rds_security_group.id
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  source_security_group_id = aws_security_group.reas_web_security_group.id
}