#!/bin/bash
echo "Monitoring Setup for Metric Alarm - Appstream"

# --- Output is 2 AppStream Alarms below.
# CapacityUtilization default scalie-in
# CapacityUtilization default scalie-out

# VARIABLES 
source variables.sh

# --alarm-actions "arn:aws:sns:ap-northeast-1:505982390831:${snsTopic}" \

# Target 1: hyoka-customer-1-appstream-fleet
# Scale-Out ------------------------------------------------------
aws cloudwatch put-metric-alarm \
--alarm-name 'Appstream2-'${accountName}'-appstream-fleet-'${fleet_name_1}'-default-scale-out-Alarm' \
--${actionsEnabled}actions-enabled \
--alarm-actions "arn:aws:sns:ap-northeast-1:505982390831:${snsTopic}" \
--metrics '{"Id":"m1","MetricStat":{"Metric":{"Namespace":"AWS/AppStream","MetricName":"CapacityUtilization","Dimensions":[{"Name":"Fleet","Value":"'$fleet_name_1'"}]},"Period":60,"Stat":"Average"},"ReturnData":true,"AccountId":"'$accountId'"}' \
--evaluation-periods 3 \
--datapoints-to-alarm 3 \
--threshold 75.0 \
--comparison-operator "GreaterThanOrEqualToThreshold" \
--treat-missing-data 'notBreaching'

# ------------------------------------------------------------------

# Scale-In ------------------------------------------------------
aws cloudwatch put-metric-alarm \
--alarm-name 'Appstream2-'${accountName}'-appstream-fleet-'${fleet_name_1}'-default-scale-in-Alarm' \
--${actionsEnabled}actions-enabled \
--alarm-actions "arn:aws:sns:ap-northeast-1:505982390831:${snsTopic}" \
--metrics '{"Id":"m1","MetricStat":{"Metric":{"Namespace":"AWS/AppStream","MetricName":"CapacityUtilization","Dimensions":[{"Name":"Fleet","Value":"'$fleet_name_1'"}]},"Period":120,"Stat":"Average"},"ReturnData":true,"AccountId":"'$accountId'"}' \
--evaluation-periods 10 \
--datapoints-to-alarm 10 \
--threshold 25.0 \
--comparison-operator "LessThanOrEqualToThreshold" \
--treat-missing-data 'notBreaching'
# ------------------------------------------------------------------

echo "All Done"
