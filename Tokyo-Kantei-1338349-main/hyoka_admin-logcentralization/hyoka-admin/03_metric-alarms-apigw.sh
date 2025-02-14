#!/bin/bash
echo "Monitoring Setup for Metric Alarm - API Gateway"


# --- Output is 8 API GW Alarms below
# API: SYSTEM API
# API: LINK API
# -- Metric for each API
# 5XXError
# 4XXError
# integrationlatency
# count

# VARIABLES 
# accountId="931756137289"
# accountName="hyoka-cloud"
# actionsEnabled=""



# ----- SYSTEM API -----
# 5XXError_Alarm ------------------------------------------------------
# change [alarm-name] and [instance ID] and [alarm/ok action account id]
#---------------------------------------------
aws cloudwatch put-metric-alarm \
--alarm-name 'hyoka-admin-apigw-system_api-5XXError-high' \
--actions-enabled \
--alarm-actions 'arn:aws:sns:ap-northeast-1:505982390831:hyoka-admin-sns-topic' \
--metric-name '5XXError' \
--namespace 'AWS/ApiGateway' \
--statistic 'Sum' \
--dimensions '[{"Name":"ApiName","Value":"SYSTEM API"}]' \
--period 300 \
--evaluation-periods 1 \
--datapoints-to-alarm 1 \
--threshold 10.0 \
--comparison-operator 'GreaterThanOrEqualToThreshold' \
--treat-missing-data 'notBreaching'
# ------------------------------------------------------------------


# 4XXError_Alarm ------------------------------------------------------
# change [alarm-name] and [instance ID] and [alarm/ok action account id]
#---------------------------------------------
aws cloudwatch put-metric-alarm \
--alarm-name 'hyoka-admin-apigw-system_api-4XXError-high' \
--actions-enabled \
--alarm-actions 'arn:aws:sns:ap-northeast-1:505982390831:hyoka-admin-sns-topic' \
--metric-name '4XXError' \
--namespace 'AWS/ApiGateway' \
--statistic 'Sum' \
--dimensions '[{"Name":"ApiName","Value":"SYSTEM API"}]' \
--period 300 \
--evaluation-periods 1 \
--datapoints-to-alarm 1 \
--threshold 10.0 \
--comparison-operator 'GreaterThanOrEqualToThreshold' \
--treat-missing-data 'notBreaching'
# ------------------------------------------------------------------


# IntegrationLatency_Alarm ------------------------------------------------------
# change [alarm-name] and [instance ID] and [alarm/ok action account id]
#---------------------------------------------
aws cloudwatch put-metric-alarm \
--alarm-name 'hyoka-admin-apigw-system_api-integrationlatency-high' \
--actions-enabled \
--alarm-actions 'arn:aws:sns:ap-northeast-1:505982390831:hyoka-admin-sns-topic' \
--metric-name 'IntegrationLatency' \
--namespace 'AWS/ApiGateway' \
--statistic 'Average' \
--dimensions '[{"Name":"ApiName","Value":"SYSTEM API"}]' \
--period 60 \
--evaluation-periods 5 \
--datapoints-to-alarm 5 \
--threshold 30000.0 \
--comparison-operator 'GreaterThanOrEqualToThreshold' \
--treat-missing-data 'notBreaching'
# ------------------------------------------------------------------


# Count_Alarm ------------------------------------------------------
# change [alarm-name] and [instance ID] and [alarm/ok action account id]
#---------------------------------------------
aws cloudwatch put-metric-alarm \
--alarm-name 'hyoka-admin-apigw-system_api-count-high' \
--actions-enabled \
--alarm-actions 'arn:aws:sns:ap-northeast-1:505982390831:hyoka-admin-sns-topic' \
--metric-name 'Count' \
--namespace 'AWS/ApiGateway' \
--statistic 'Sum' \
--dimensions '[{"Name":"ApiName","Value":"SYSTEM API"}]' \
--period 60 \
--evaluation-periods 5 \
--datapoints-to-alarm 5 \
--threshold 10000.0 \
--comparison-operator 'GreaterThanOrEqualToThreshold' \
--treat-missing-data 'notBreaching'
# ------------------------------------------------------------------


# ----- LINK API -----
# 5XXError_Alarm ------------------------------------------------------
# change [alarm-name] and [instance ID] and [alarm/ok action account id]
#---------------------------------------------
aws cloudwatch put-metric-alarm \
--alarm-name 'hyoka-admin-apigw-link_api-5XXError-high' \
--actions-enabled \
--alarm-actions 'arn:aws:sns:ap-northeast-1:505982390831:hyoka-admin-sns-topic' \
--metric-name '5XXError' \
--namespace 'AWS/ApiGateway' \
--statistic 'Sum' \
--dimensions '[{"Name":"ApiName","Value":"LINK API"}]' \
--period 300 \
--evaluation-periods 1 \
--datapoints-to-alarm 1 \
--threshold 10.0 \
--comparison-operator 'GreaterThanOrEqualToThreshold' \
--treat-missing-data 'notBreaching'
# ------------------------------------------------------------------


# 4XXError_Alarm ------------------------------------------------------
# change [alarm-name] and [instance ID] and [alarm/ok action account id]
#---------------------------------------------
aws cloudwatch put-metric-alarm \
--alarm-name 'hyoka-admin-apigw-link_api-4XXError-high' \
--actions-enabled \
--alarm-actions 'arn:aws:sns:ap-northeast-1:505982390831:hyoka-admin-sns-topic' \
--metric-name '4XXError' \
--namespace 'AWS/ApiGateway' \
--statistic 'Sum' \
--dimensions '[{"Name":"ApiName","Value":"LINK API"}]' \
--period 300 \
--evaluation-periods 1 \
--datapoints-to-alarm 1 \
--threshold 10.0 \
--comparison-operator 'GreaterThanOrEqualToThreshold' \
--treat-missing-data 'notBreaching'
# ------------------------------------------------------------------


# IntegrationLatency_Alarm ------------------------------------------------------
# change [alarm-name] and [instance ID] and [alarm/ok action account id]
#---------------------------------------------
aws cloudwatch put-metric-alarm \
--alarm-name 'hyoka-admin-apigw-link_api-integrationlatency-high' \
--actions-enabled \
--alarm-actions 'arn:aws:sns:ap-northeast-1:505982390831:hyoka-admin-sns-topic' \
--metric-name 'IntegrationLatency' \
--namespace 'AWS/ApiGateway' \
--statistic 'Average' \
--dimensions '[{"Name":"ApiName","Value":"LINK API"}]' \
--period 60 \
--evaluation-periods 5 \
--datapoints-to-alarm 5 \
--threshold 30000.0 \
--comparison-operator 'GreaterThanOrEqualToThreshold' \
--treat-missing-data 'notBreaching'
# ------------------------------------------------------------------


# Count_Alarm ------------------------------------------------------
# change [alarm-name] and [instance ID] and [alarm/ok action account id]
#---------------------------------------------
aws cloudwatch put-metric-alarm \
--alarm-name 'hyoka-admin-apigw-link_api-count-high' \
--actions-enabled \
--alarm-actions 'arn:aws:sns:ap-northeast-1:505982390831:hyoka-admin-sns-topic' \
--metric-name 'Count' \
--namespace 'AWS/ApiGateway' \
--statistic 'Sum' \
--dimensions '[{"Name":"ApiName","Value":"LINK API"}]' \
--period 60 \
--evaluation-periods 5 \
--datapoints-to-alarm 5 \
--threshold 10000.0 \
--comparison-operator 'GreaterThanOrEqualToThreshold' \
--treat-missing-data 'notBreaching'
# ------------------------------------------------------------------


echo "All Done"