##### 1. Appstream Image Security Group ######
resource "aws_security_group" "hyoka_admin_appstream_image_security_group" {
  name_prefix            = "${var.app_name_env_code}-appstream-image-sg"
  description            = "AppStream Image Group"
  vpc_id                 = module.base_network.vpc_id
  revoke_rules_on_delete = true

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.tags, map("Name", "${var.app_name_env_code}-appstream-image-sg"))
}

resource "aws_security_group_rule" "hyoka_admin_appstream_all_egress" {
  type              = "egress"
  security_group_id = aws_security_group.hyoka_admin_appstream_image_security_group.id
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "hyoka_admin_appstream_kantei_ingress" {
  type              = "ingress"
  security_group_id = aws_security_group.hyoka_admin_appstream_image_security_group.id
  cidr_blocks = ["140.227.46.69/32"]
  description = "From Tokyo Kantei"
  from_port   = "0"
  protocol    = "tcp"
  self        = "false"
  to_port     = "65535"
}

resource "aws_security_group_rule" "hyoka_admin_appstream_self_ingress" {
  type              = "ingress"
  security_group_id = aws_security_group.hyoka_admin_appstream_image_security_group.id
  description = "From same SG"
  from_port   = "0"
  protocol    = "-1"
  self        = "true"
  to_port     = "0"
}


##### 2. Appstream VPC Endpoint Security Group ######
resource "aws_security_group" "hyoka_admin_appstream_endpoint_security_group" {
  name_prefix            = "${var.app_name_env_code}-appstream-vpce-sg"
  description            = "AppStream Endpoint Group"
  vpc_id                 = module.base_network.vpc_id
  revoke_rules_on_delete = true

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.tags, map("Name", "${var.app_name_env_code}-appstream-vpce-sg"))
}

resource "aws_security_group_rule" "hyoka_admin_appstream_endpoint_all_egress" {
  type              = "egress"
  security_group_id = aws_security_group.hyoka_admin_appstream_endpoint_security_group.id
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "hyoka_admin_appstream_endpoint_kantei_ingress" {
  type              = "ingress"
  security_group_id = aws_security_group.hyoka_admin_appstream_endpoint_security_group.id
  cidr_blocks = ["10.160.13.0/24"]
  description = "From VPC"
  from_port   = "0"
  protocol    = "tcp"
  self        = "false"
  to_port     = "65535"
}


##### 3. API Gateway Endpoint Security Group ######
resource "aws_security_group" "hyoka_admin_apigw_endpoint_security_group" {
  name_prefix            = "${var.app_name_env_code}-apigw-vpce-sg"
  description            = "API Gateway Endpoint Group"
  vpc_id                 = module.base_network.vpc_id
  revoke_rules_on_delete = true

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.tags, map("Name", "${var.app_name_env_code}-apigw-vpce-sg"))
}

# All Ingress -------
resource "aws_security_group_rule" "hyoka_admin_apigw_all_ingress" {
  type              = "ingress"
  security_group_id = aws_security_group.hyoka_admin_apigw_endpoint_security_group.id
  description       = "From IIJ"
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  cidr_blocks       = ["10.11.0.0/16"]
}

# All Ingress Self -------
resource "aws_security_group_rule" "hyoka_admin_apigw_self_all_ingress" {
  type              = "ingress"
  security_group_id = aws_security_group.hyoka_admin_apigw_endpoint_security_group.id
  description       = "From same SG"
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  source_security_group_id = aws_security_group.hyoka_admin_apigw_endpoint_security_group.id
}

# TCP 0 - 65535 Ingress -------
resource "aws_security_group_rule" "hyoka_admin_apigw_endpoint_kantei_ingress" {
  type              = "ingress"
  security_group_id = aws_security_group.hyoka_admin_apigw_endpoint_security_group.id
  cidr_blocks = ["10.160.13.0/24"]
  description = "From VPC"
  from_port   = "0"
  protocol    = "tcp"
  self        = "false"
  to_port     = "65535"
}

# All Egress ------
resource "aws_security_group_rule" "hyoka_admin_apigw_endpoint_all_egress" {
  type              = "egress"
  security_group_id = aws_security_group.hyoka_admin_apigw_endpoint_security_group.id
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}


##### 4. RDS Security Group ##### 
resource "aws_security_group" "hyoka_admin_rds_security_group" {
  name_prefix            = "${var.app_name_env_code}-rds-sg"
  description            = "RDS Security Group"
  vpc_id                 = module.base_network.vpc_id
  revoke_rules_on_delete = true

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.tags, map("Name", "${var.app_name_env_code}-rds-sg"))
}

# Ingress ----------
resource "aws_security_group_rule" "hyoka_admin_postresql_ingress" {
  type              = "ingress"
  security_group_id = aws_security_group.hyoka_admin_rds_security_group.id
  to_port           = 5432
  from_port         = 5432
  protocol          = "tcp"
  cidr_blocks       = ["10.160.13.0/26", "10.160.13.64/26"]
}

resource "aws_security_group_rule" "hyoka_admin_microsoftsqlserver_ingress" {
  type              = "ingress"
  security_group_id = aws_security_group.hyoka_admin_rds_security_group.id
  to_port           = 1433
  from_port         = 1433
  protocol          = "tcp"
  cidr_blocks       = ["10.160.13.0/26", "10.160.13.64/26"]
}

resource "aws_security_group_rule" "hyoka_admin_microsoftsqlserver_self_ingress" {
  type              = "ingress"
  security_group_id = aws_security_group.hyoka_admin_rds_security_group.id
  to_port           = 1433
  from_port         = 1433
  protocol          = "tcp"
  source_security_group_id = aws_security_group.hyoka_admin_lambda_security_group.id
}

# Egress ----------
resource "aws_security_group_rule" "hyoka_admin_rds_all_egress" {
  type              = "egress"
  security_group_id = aws_security_group.hyoka_admin_rds_security_group.id
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}


##### 5. Lambda Security Group ######
resource "aws_security_group" "hyoka_admin_lambda_security_group" {
  name_prefix            = "${var.app_name_env_code}-lambda-sg"
  description            = "Lambda Group"
  vpc_id                 = module.base_network.vpc_id
  revoke_rules_on_delete = true

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.tags, map("Name", "${var.app_name_env_code}-lambda-sg"))
}

resource "aws_security_group_rule" "hyoka_admin_lambda_all_egress" {
  type              = "egress"
  security_group_id = aws_security_group.hyoka_admin_lambda_security_group.id
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}