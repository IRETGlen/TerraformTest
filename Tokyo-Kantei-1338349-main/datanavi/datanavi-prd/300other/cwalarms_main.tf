module "alarm_5XX" {
 source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-cloudwatch_alarm//?ref=v0.12.6"
 comparison_operator      = "GreaterThanOrEqualToThreshold"
 evaluation_periods       = 1
 metric_name              = "5XXError"
 name                     = "${var.api_name}_5XXError_Alarm"
 namespace                = "AWS/ApiGateway"
 period                   = 300
 rackspace_managed        = true
 statistic                = "Sum"
 threshold                = 1.0
 dimensions = [{
   "ApiName" = var.api_name
 }]
}

module "alarm_4XX" {
 source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-cloudwatch_alarm//?ref=v0.12.6"
 comparison_operator      = "GreaterThanOrEqualToThreshold"
 evaluation_periods       = 1
 metric_name              = "4XXError"
 name                     = "${var.api_name}_4XXError_Alarm"
 namespace                = "AWS/ApiGateway"
 period                   = 300
 rackspace_managed        = true
 statistic                = "Sum"
 threshold                = 1.0
 dimensions = [{
   "ApiName" = var.api_name
 }]
}

module "alarm_integrationlatency" {
 source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-cloudwatch_alarm//?ref=v0.12.6"
 comparison_operator      = "GreaterThanOrEqualToThreshold"
 evaluation_periods       = 5
 metric_name              = "IntegrationLatency"
 name                     = "${var.api_name}_integrationlatency"
 namespace                = "AWS/ApiGateway"
 period                   = 60 //per min
 rackspace_managed        = true
 statistic                = "Average"
 #threshold                = 3000 //3s -> reason: confirmed over 2100 latency in existing customer account 
 threshold                = 30000 //30s -> reason: updated to 10X regular metric to evaluate 'major' latency 
 unit                     = "Milliseconds"
 dimensions = [{
   "ApiName" = var.api_name
 }]
}