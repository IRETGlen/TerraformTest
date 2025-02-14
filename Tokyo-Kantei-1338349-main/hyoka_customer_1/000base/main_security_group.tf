##### 1. Appstream Image Security Group ######
resource "aws_security_group" "hyoka_appstream_image_security_group" {
  name_prefix            = "${var.app_name_env_code}-appstream-image-sg"
  description            = "AppStream Image Group"
  vpc_id                 = module.base_network.vpc_id
  revoke_rules_on_delete = true

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.tags, tomap({"Name"="${var.app_name_env_code}-appstream-image-sg"})
  )
}

resource "aws_security_group_rule" "hyoka_appstream_all_egress" {
  type              = "egress"
  security_group_id = aws_security_group.hyoka_appstream_image_security_group.id
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "hyoka_appstream_kantei_ingress" {
  type              = "ingress"
  security_group_id = aws_security_group.hyoka_appstream_image_security_group.id
  cidr_blocks = var.tokyo_kantei_cidr
  description = "From Tokyo Kantei"
  from_port   = "0"
  protocol    = "tcp"
  self        = "false"
  to_port     = "65535"
}

resource "aws_security_group_rule" "hyoka_appstream_self_ingress" {
  type              = "ingress"
  security_group_id = aws_security_group.hyoka_appstream_image_security_group.id
  description = "From same SG"
  from_port   = "0"
  protocol    = "-1"
  self        = "true"
  to_port     = "0"
}


##### 2. API Gateway Endpoint Security Group ######
resource "aws_security_group" "hyoka_apigw_endpoint_security_group" {
  name_prefix            = "${var.app_name_env_code}-apigw-vpce-sg"
  description            = "API Gateway Endpoint Group"
  vpc_id                 = module.base_network.vpc_id
  revoke_rules_on_delete = true

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.tags, tomap({"Name"="${var.app_name_env_code}-apigw-vpce-sg"}))
}

# All Ingress -------
resource "aws_security_group_rule" "hyoka_apigw_all_ingress" {
  type              = "ingress"
  security_group_id = aws_security_group.hyoka_apigw_endpoint_security_group.id
  description       = "From IIJ"
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  cidr_blocks       = var.iij_cidr
}

# All Ingress Self -------
resource "aws_security_group_rule" "hyoka_apigw_self_all_ingress" {
  type              = "ingress"
  security_group_id = aws_security_group.hyoka_apigw_endpoint_security_group.id
  description       = "From same SG"
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  source_security_group_id = aws_security_group.hyoka_apigw_endpoint_security_group.id
}

# TCP 0 - 65535 Ingress -------
resource "aws_security_group_rule" "hyoka_apigw_endpoint_kantei_ingress" {
  type              = "ingress"
  security_group_id = aws_security_group.hyoka_apigw_endpoint_security_group.id
  cidr_blocks = [var.cidr_range]
  description = "From VPC"
  from_port   = "0"
  protocol    = "tcp"
  self        = "false"
  to_port     = "65535"
}

# All Egress ------
resource "aws_security_group_rule" "hyoka_apigw_endpoint_all_egress" {
  type              = "egress"
  security_group_id = aws_security_group.hyoka_apigw_endpoint_security_group.id
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}


##### 3. RDS Security Group ##### 
resource "aws_security_group" "hyoka_rds_security_group" {
  name_prefix            = "${var.app_name_env_code}-rds-sg"
  description            = "RDS Security Group"
  vpc_id                 = module.base_network.vpc_id
  revoke_rules_on_delete = true

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.tags, tomap({"Name"="${var.app_name_env_code}-rds-sg"}))
}

# Ingress ----------
resource "aws_security_group_rule" "hyoka_postresql_ingress" {
  type              = "ingress"
  security_group_id = aws_security_group.hyoka_rds_security_group.id
  to_port           = 5432
  from_port         = 5432
  protocol          = "tcp"
  cidr_blocks       = var.public_cidr_ranges
  description       = "From public subnets 1a/1c"
}

resource "aws_security_group_rule" "hyoka_microsoftsqlserver_ingress" {
  type              = "ingress"
  security_group_id = aws_security_group.hyoka_rds_security_group.id
  to_port           = 1433
  from_port         = 1433
  protocol          = "tcp"
  cidr_blocks       = var.public_cidr_ranges
  description       = "From public subnets 1a/1c"
  
}

resource "aws_security_group_rule" "hyoka_microsoftsqlserver_self_ingress" {
  type              = "ingress"
  security_group_id = aws_security_group.hyoka_rds_security_group.id
  to_port           = 1433
  from_port         = 1433
  protocol          = "tcp"
  source_security_group_id = aws_security_group.hyoka_lambda_security_group.id
  description       = "From lambda-sg"
}

resource "aws_security_group_rule" "hyoka_postgresqlserver_self_ingress" {
  type              = "ingress"
  security_group_id = aws_security_group.hyoka_rds_security_group.id
  to_port           = 5432
  from_port         = 5432
  protocol          = "tcp"
  source_security_group_id = aws_security_group.hyoka_lambda_security_group.id
  description       = "From lambda-sg"
}

# Egress ----------
resource "aws_security_group_rule" "hyoka_rds_all_egress" {
  type              = "egress"
  security_group_id = aws_security_group.hyoka_rds_security_group.id
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}


##### 4. Lambda Security Group ######
resource "aws_security_group" "hyoka_lambda_security_group" {
  name_prefix            = "${var.app_name_env_code}-lambda-sg"
  description            = "Lambda Group"
  vpc_id                 = module.base_network.vpc_id
  revoke_rules_on_delete = true

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.tags, tomap({"Name"="${var.app_name_env_code}-lambda-sg"}))
}

resource "aws_security_group_rule" "hyoka_lambda_all_egress" {
  type              = "egress"
  security_group_id = aws_security_group.hyoka_lambda_security_group.id
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

##### 5. S3 VPC Endpoint Interface Security Group ######
resource "aws_security_group" "hyoka_s3_endpoint_security_group" {
  name_prefix            = "${var.app_name_env_code}-s3-vpce-if-sg"
  description            = "S3 VPC Endpoint Group"
  vpc_id                 = module.base_network.vpc_id
  revoke_rules_on_delete = true

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.tags, tomap({"Name"="${var.app_name_env_code}-s3-vpce-if-sg"})
  )
}

resource "aws_security_group_rule" "hyoka_s3_endpoint_all_egress" {
  type              = "egress"
  security_group_id = aws_security_group.hyoka_s3_endpoint_security_group.id
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "hyoka_s3_endpoint_iij_ingress" {
  type              = "ingress"
  security_group_id = aws_security_group.hyoka_s3_endpoint_security_group.id
  cidr_blocks = var.iij_cidr
  description = "From IIJ"
  to_port     = 443
  from_port   = 443
  protocol    = "tcp"
  self        = "false"
}