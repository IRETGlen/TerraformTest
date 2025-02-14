#!/bin/bash
echo "Monitoring Setup for Metric Alarm - RDS"


# --- Output is 3 RDS Alarms below
# -- Metric Alarm - RDS (3)
# WriteIOHigh 
# ReadIOHigh 
# CPUAlarmHigh 

# VARIABLES 
source variables.sh

# WriteIOHigh ------------------------------------------------------
aws cloudwatch put-metric-alarm \
--alarm-name ''${rds_name}'-writeiops-high' \
--${actionsEnabled}actions-enabled \
--alarm-actions "arn:aws:sns:ap-northeast-1:505982390831:${snsTopic}" \
--metrics '{"Id":"m1","MetricStat":{"Metric":{"Namespace":"AWS/RDS","MetricName":"WriteIOPS","Dimensions":[{"Name":"DBInstanceIdentifier","Value":"'$db_identifier'"}]},"Period":60,"Stat":"Average"},"ReturnData":true,"AccountId":"'$accountId'"}' \
--evaluation-periods 5 \
--datapoints-to-alarm 5 \
--threshold 100.0 \
--comparison-operator 'GreaterThanThreshold' \
--treat-missing-data 'notBreaching'
# ------------------------------------------------------------------


# ReadIOHigh ------------------------------------------------------
aws cloudwatch put-metric-alarm \
--alarm-name ''${rds_name}'-readiops-high' \
--${actionsEnabled}actions-enabled \
--alarm-actions "arn:aws:sns:ap-northeast-1:505982390831:${snsTopic}" \
--metrics '{"Id":"m1","MetricStat":{"Metric":{"Namespace":"AWS/RDS","MetricName":"ReadIOPS","Dimensions":[{"Name":"DBInstanceIdentifier","Value":"'$db_identifier'"}]},"Period":60,"Stat":"Average"},"ReturnData":true,"AccountId":"'$accountId'"}' \
--evaluation-periods 5 \
--datapoints-to-alarm 5 \
--threshold 100.0 \
--comparison-operator 'GreaterThanThreshold' \
--treat-missing-data 'notBreaching'
# ------------------------------------------------------------------


# CPUAlarmHigh ------------------------------------------------------
aws cloudwatch put-metric-alarm \
--alarm-name ''${rds_name}'-cpu-high' \
--${actionsEnabled}actions-enabled \
--alarm-actions "arn:aws:sns:ap-northeast-1:505982390831:${snsTopic}" \
--metrics '{"Id":"m1","MetricStat":{"Metric":{"Namespace":"AWS/RDS","MetricName":"CPUUtilization","Dimensions":[{"Name":"DBInstanceIdentifier","Value":"'$db_identifier'"}]},"Period":60,"Stat":"Average"},"ReturnData":true,"AccountId":"'$accountId'"}' \
--evaluation-periods 15 \
--datapoints-to-alarm 15 \
--threshold 60.0 \
--comparison-operator 'GreaterThanThreshold' \
--treat-missing-data 'notBreaching'
# ------------------------------------------------------------------

echo "All Done"