# -----------------------------------------------
# API Gateway
# -- 5XXError
# -- 4XXError
# -- IntegrationLatency
# -- Count
# -----------------------------------------------
resource "aws_cloudwatch_metric_alarm" "systemapi_alarm_5XX" {
  alarm_name               = "${var.app_name_env_code}-${var.systemapi_name}-5XXError-high"
  comparison_operator      = "GreaterThanOrEqualToThreshold"
  evaluation_periods       = 1
  metric_name              = "5XXError"
  namespace                = "AWS/ApiGateway"
  period                   = 300
  statistic                = "Sum"
  threshold                = 10.0
  dimensions = {
    ApiName = "SYSTEM API"
  }
}

resource "aws_cloudwatch_metric_alarm" "systemapi_alarm_4XX" {
  alarm_name               = "${var.app_name_env_code}-${var.systemapi_name}-4XXError-high"
  comparison_operator      = "GreaterThanOrEqualToThreshold"
  evaluation_periods       = 1
  metric_name              = "4XXError"
  namespace                = "AWS/ApiGateway"
  period                   = 300
  statistic                = "Sum"
  threshold                = 10.0
  dimensions = {
    ApiName = "SYSTEM API"
  }
}

resource "aws_cloudwatch_metric_alarm" "systemapi_alarm_integrationlatency" {
 comparison_operator      = "GreaterThanOrEqualToThreshold"
 evaluation_periods       = 5
 metric_name              = "IntegrationLatency"
 alarm_name               = "${var.app_name_env_code}-${var.systemapi_name}-integrationlatency-high"
 namespace                = "AWS/ApiGateway"
 period                   = 60 //per min
 statistic                = "Average"
 threshold                = 30000 //30s -> reason: updated to 10X regular metric to evaluate 'major' latency 
 unit                     = "Milliseconds"
  dimensions = {
    ApiName = "SYSTEM API"
  }
}

resource "aws_cloudwatch_metric_alarm" "systemapi_alarm_count" {
  comparison_operator      = "GreaterThanOrEqualToThreshold"
  evaluation_periods       = 5
  metric_name              = "Count"
  alarm_name               = "${var.app_name_env_code}-${var.systemapi_name}-count-high"
  namespace                = "AWS/ApiGateway"
  period                   = 60 //per min
  statistic                = "Sum"
  threshold                = 10000
  dimensions = {
    ApiName = "SYSTEM API"
  }
}

resource "aws_cloudwatch_metric_alarm" "linkapi_alarm_5XX" {
  alarm_name               = "${var.app_name_env_code}-${var.linkapi_name}-5XXError-high"
  comparison_operator      = "GreaterThanOrEqualToThreshold"
  evaluation_periods       = 1
  metric_name              = "5XXError"
  namespace                = "AWS/ApiGateway"
  period                   = 300
  statistic                = "Sum"
  threshold                = 10.0
  dimensions = {
    ApiName = "LINK API"
  }
}

resource "aws_cloudwatch_metric_alarm" "linkapi_alarm_4XX" {
  alarm_name               = "${var.app_name_env_code}-${var.linkapi_name}-4XXError-high"
  comparison_operator      = "GreaterThanOrEqualToThreshold"
  evaluation_periods       = 1
  metric_name              = "4XXError"
  namespace                = "AWS/ApiGateway"
  period                   = 300
  statistic                = "Sum"
  threshold                = 10.0
  dimensions = {
    ApiName = "LINK API"
  }
}

resource "aws_cloudwatch_metric_alarm" "linkapi_alarm_integrationlatency" {
 comparison_operator      = "GreaterThanOrEqualToThreshold"
 evaluation_periods       = 5
 metric_name              = "IntegrationLatency"
 alarm_name               = "${var.app_name_env_code}-${var.linkapi_name}-integrationlatency-high"
 namespace                = "AWS/ApiGateway"
 period                   = 60 //per min
 statistic                = "Average"
 threshold                = 30000 //30s -> reason: updated to 10X regular metric to evaluate 'major' latency 
 unit                     = "Milliseconds"
  dimensions = {
    ApiName = "LINK API"
  }
}

resource "aws_cloudwatch_metric_alarm" "linkapi_alarm_count" {
  comparison_operator      = "GreaterThanOrEqualToThreshold"
  evaluation_periods       = 5
  metric_name              = "Count"
  alarm_name               = "${var.app_name_env_code}-${var.linkapi_name}-count-high"
  namespace                = "AWS/ApiGateway"
  period                   = 60 //per min
  statistic                = "Sum"
  threshold                = 10000
  dimensions = {
    ApiName = "LINK API"
  }
}

# -----------------------------------------------
# Lambda
# -- Errors
# -----------------------------------------------
resource "aws_cloudwatch_metric_alarm" "lambda_alarm_errors" {
  for_each                 = toset(var.lambda_list)
  comparison_operator      = "GreaterThanOrEqualToThreshold"
  evaluation_periods       = 15
  metric_name              = "Errors"
  alarm_name               = "${var.app_name_env_code}-lambda-${each.value}-error-high"
  namespace                = "AWS/Lambda"
  period                   = 60 //per min
  statistic                = "Sum"
  threshold                = 5.0
  dimensions = {
    FunctionName = each.value
  }
}
