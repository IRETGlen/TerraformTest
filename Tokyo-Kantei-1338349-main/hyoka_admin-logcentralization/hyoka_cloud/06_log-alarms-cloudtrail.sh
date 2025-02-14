#!/bin/bash
echo "Monitoring Setup for Log Alarm - Cloudtrail"

# --- Output is 4 Cloudtrail Log Alarms below
# ListDescribeAPICall 
# CreateAPICall 
# ModifyAPICall 
# APICallNotInTokyo 

# VARIABLES 
accountId="931756137289"
accountName="hyoka-cloud"
acctionsEnabled=""

# ListDescribeAPICall ------------------------------------------------------
aws cloudwatch put-metric-alarm \
--alarm-name ''${accountName}'-cloudtraillogs-ListDescribeAPICall-high' \
--${acctionsEnabled}actions-enabled \
--alarm-actions 'arn:aws:sns:ap-northeast-1:505982390831:hyoka-cloud-sns-topic' \
--metrics '{"Id":"m1","MetricStat":{"Metric":{"Namespace":"CloudTrailMetrics","MetricName":"ListDescribeAPICall","Dimensions":[]},"Period":300,"Stat":"Sum"},"ReturnData":true,"AccountId":"'$accountId'"}' \
--evaluation-periods 1 \
--datapoints-to-alarm 1 \
--threshold 50 \
--comparison-operator "GreaterThanOrEqualToThreshold" \
--treat-missing-data 'notBreaching'
# ------------------------------------------------------------------


# CreateAPICall ------------------------------------------------------
aws cloudwatch put-metric-alarm \
--alarm-name ''${accountName}'-cloudtraillogs-CreateAPICall-high' \
--${acctionsEnabled}actions-enabled \
--alarm-actions 'arn:aws:sns:ap-northeast-1:505982390831:hyoka-cloud-sns-topic' \
--metrics '{"Id":"m1","MetricStat":{"Metric":{"Namespace":"CloudTrailMetrics","MetricName":"CreateAPICall","Dimensions":[]},"Period":300,"Stat":"Sum"},"ReturnData":true,"AccountId":"'$accountId'"}' \
--evaluation-periods 1 \
--datapoints-to-alarm 1 \
--threshold 20 \
--comparison-operator "GreaterThanOrEqualToThreshold" \
--treat-missing-data 'notBreaching'
# ------------------------------------------------------------------


# ModifyAPICall ------------------------------------------------------
aws cloudwatch put-metric-alarm \
--alarm-name ''${accountName}'-cloudtraillogs-ModifyAPICall-high' \
--${acctionsEnabled}actions-enabled \
--alarm-actions 'arn:aws:sns:ap-northeast-1:505982390831:hyoka-cloud-sns-topic' \
--metrics '{"Id":"m1","MetricStat":{"Metric":{"Namespace":"CloudTrailMetrics","MetricName":"ModifyAPICall","Dimensions":[]},"Period":300,"Stat":"Sum"},"ReturnData":true,"AccountId":"'$accountId'"}' \
--evaluation-periods 1 \
--datapoints-to-alarm 1 \
--threshold 20 \
--comparison-operator "GreaterThanOrEqualToThreshold" \
--treat-missing-data 'notBreaching'
# ------------------------------------------------------------------


# APICallNotInTokyo ------------------------------------------------------
aws cloudwatch put-metric-alarm \
--alarm-name ''${accountName}'-cloudtraillogs-APICallNotInTokyo-high' \
--${acctionsEnabled}actions-enabled \
--alarm-actions 'arn:aws:sns:ap-northeast-1:505982390831:hyoka-cloud-sns-topic' \
--metrics '{"Id":"m1","MetricStat":{"Metric":{"Namespace":"CloudTrailMetrics","MetricName":"APICallNotInTokyo","Dimensions":[]},"Period":300,"Stat":"Sum"},"ReturnData":true,"AccountId":"'$accountId'"}' \
--evaluation-periods 1 \
--datapoints-to-alarm 1 \
--threshold 20 \
--comparison-operator "GreaterThanOrEqualToThreshold" \
--treat-missing-data 'notBreaching'
# ------------------------------------------------------------------

echo "All Done"