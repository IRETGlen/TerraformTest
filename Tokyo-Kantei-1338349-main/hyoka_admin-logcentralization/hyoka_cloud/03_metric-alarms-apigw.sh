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
accountId="931756137289"
accountName="hyoka-cloud"
actionsEnabled=""


# ----- LINK API -----
# 4XXError_Alarm ------------------------------------------------------
aws cloudwatch put-metric-alarm \
--alarm-name ''${accountName}'-apigw-link_api-4XXError-high' \
--${acctionsEnabled}actions-enabled \
--alarm-actions 'arn:aws:sns:ap-northeast-1:505982390831:hyoka-cloud-sns-topic' \
--metrics '{"Id":"m1","MetricStat":{"Metric":{"Namespace":"AWS/ApiGateway","MetricName":"4XXError","Dimensions":[{"Name":"ApiName","Value":"LINK API"}]},"Period":300,"Stat":"Sum"},"ReturnData":true,"AccountId":"'$accountId'"}' \
--evaluation-periods 1 \
--datapoints-to-alarm 1 \
--threshold 10.0 \
--comparison-operator 'GreaterThanOrEqualToThreshold' \
--treat-missing-data 'notBreaching'
# ------------------------------------------------------------------


# 5XXError_Alarm ------------------------------------------------------
aws cloudwatch put-metric-alarm \
--alarm-name ''${accountName}'-apigw-link_api-5XXError-high' \
--${acctionsEnabled}actions-enabled \
--alarm-actions 'arn:aws:sns:ap-northeast-1:505982390831:hyoka-cloud-sns-topic' \
--metrics '{"Id":"m1","MetricStat":{"Metric":{"Namespace":"AWS/ApiGateway","MetricName":"5XXError","Dimensions":[{"Name":"ApiName","Value":"LINK API"}]},"Period":300,"Stat":"Sum"},"ReturnData":true,"AccountId":"'$accountId'"}' \
--evaluation-periods 1 \
--datapoints-to-alarm 1 \
--threshold 10.0 \
--comparison-operator 'GreaterThanOrEqualToThreshold' \
--treat-missing-data 'notBreaching'
# ------------------------------------------------------------------


# # IntegrationLatency_Alarm ------------------------------------------------------
aws cloudwatch put-metric-alarm \
--alarm-name ''${accountName}'-apigw-link_api-integrationlatency-high' \
--${acctionsEnabled}actions-enabled \
--alarm-actions 'arn:aws:sns:ap-northeast-1:505982390831:hyoka-cloud-sns-topic' \
--metrics '{"Id":"m1","MetricStat":{"Metric":{"Namespace":"AWS/ApiGateway","MetricName":"IntegrationLatency","Dimensions":[{"Name":"ApiName","Value":"LINK API"}]},"Period":60,"Stat":"Average"},"ReturnData":true,"AccountId":"'$accountId'"}' \
--evaluation-periods 5 \
--datapoints-to-alarm 5 \
--threshold 30000.0 \
--comparison-operator 'GreaterThanOrEqualToThreshold' \
--treat-missing-data 'notBreaching'
# ------------------------------------------------------------------


# # Count_Alarm ------------------------------------------------------
aws cloudwatch put-metric-alarm \
--alarm-name ''${accountName}'-apigw-link_api-count-high' \
--${acctionsEnabled}actions-enabled \
--alarm-actions 'arn:aws:sns:ap-northeast-1:505982390831:hyoka-cloud-sns-topic' \
--metrics '{"Id":"m1","MetricStat":{"Metric":{"Namespace":"AWS/ApiGateway","MetricName":"Count","Dimensions":[{"Name":"ApiName","Value":"LINK API"}]},"Period":60,"Stat":"Sum"},"ReturnData":true,"AccountId":"'$accountId'"}' \
--evaluation-periods 5 \
--datapoints-to-alarm 5 \
--threshold 10000.0 \
--comparison-operator 'GreaterThanOrEqualToThreshold' \
--treat-missing-data 'notBreaching'
# ------------------------------------------------------------------


# ----- SYSTEM API -----
# 4XXError_Alarm ------------------------------------------------------
aws cloudwatch put-metric-alarm \
--alarm-name ''${accountName}'-apigw-system_api-4XXError-high' \
--${acctionsEnabled}actions-enabled \
--alarm-actions 'arn:aws:sns:ap-northeast-1:505982390831:hyoka-cloud-sns-topic' \
--metrics '{"Id":"m1","MetricStat":{"Metric":{"Namespace":"AWS/ApiGateway","MetricName":"4XXError","Dimensions":[{"Name":"ApiName","Value":"SYSTEM API"}]},"Period":300,"Stat":"Sum"},"ReturnData":true,"AccountId":"'$accountId'"}' \
--evaluation-periods 1 \
--datapoints-to-alarm 1 \
--threshold 10.0 \
--comparison-operator 'GreaterThanOrEqualToThreshold' \
--treat-missing-data 'notBreaching'
# ------------------------------------------------------------------


# 5XXError_Alarm ------------------------------------------------------
aws cloudwatch put-metric-alarm \
--alarm-name ''${accountName}'-apigw-system_api-5XXError-high' \
--${acctionsEnabled}actions-enabled \
--alarm-actions 'arn:aws:sns:ap-northeast-1:505982390831:hyoka-cloud-sns-topic' \
--metrics '{"Id":"m1","MetricStat":{"Metric":{"Namespace":"AWS/ApiGateway","MetricName":"5XXError","Dimensions":[{"Name":"ApiName","Value":"SYSTEM API"}]},"Period":300,"Stat":"Sum"},"ReturnData":true,"AccountId":"'$accountId'"}' \
--evaluation-periods 1 \
--datapoints-to-alarm 1 \
--threshold 10.0 \
--comparison-operator 'GreaterThanOrEqualToThreshold' \
--treat-missing-data 'notBreaching'
# ------------------------------------------------------------------


# # IntegrationLatency_Alarm ------------------------------------------------------
aws cloudwatch put-metric-alarm \
--alarm-name ''${accountName}'-apigw-system_api-integrationlatency-high' \
--${acctionsEnabled}actions-enabled \
--alarm-actions 'arn:aws:sns:ap-northeast-1:505982390831:hyoka-cloud-sns-topic' \
--metrics '{"Id":"m1","MetricStat":{"Metric":{"Namespace":"AWS/ApiGateway","MetricName":"IntegrationLatency","Dimensions":[{"Name":"ApiName","Value":"SYSTEM API"}]},"Period":60,"Stat":"Average"},"ReturnData":true,"AccountId":"'$accountId'"}' \
--evaluation-periods 5 \
--datapoints-to-alarm 5 \
--threshold 30000.0 \
--comparison-operator 'GreaterThanOrEqualToThreshold' \
--treat-missing-data 'notBreaching'
# ------------------------------------------------------------------


# # Count_Alarm ------------------------------------------------------
aws cloudwatch put-metric-alarm \
--alarm-name ''${accountName}'-apigw-system_api-count-high' \
--${acctionsEnabled}actions-enabled \
--alarm-actions 'arn:aws:sns:ap-northeast-1:505982390831:hyoka-cloud-sns-topic' \
--metrics '{"Id":"m1","MetricStat":{"Metric":{"Namespace":"AWS/ApiGateway","MetricName":"Count","Dimensions":[{"Name":"ApiName","Value":"SYSTEM API"}]},"Period":60,"Stat":"Sum"},"ReturnData":true,"AccountId":"'$accountId'"}' \
--evaluation-periods 5 \
--datapoints-to-alarm 5 \
--threshold 10000.0 \
--comparison-operator 'GreaterThanOrEqualToThreshold' \
--treat-missing-data 'notBreaching'
# ------------------------------------------------------------------


echo "All Done"