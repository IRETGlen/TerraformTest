#!/bin/bash
echo "Monitoring Setup for Metric Alarm - Appstream"

# --- Output is 4 AppStream Alarms below. 2 for each target
# CapacityUtilization default scalie-in
# CapacityUtilization default scalie-out

# Target Resources for hyoka_cloud
# shusys
# shusys-prv

# 
# Appstream2-{FleetName}-{ScalingPolicy}-Alarm 

# Appstream2-shusys-default-scale-in-Alarm 
# Appstream2-shusys-prv-default-scale-in-Alarm 

# Appstream2-hyoka-cloud-appstream-fleet-shusys-default-scale-in-Alarm 
# Appstream2-hyoka-cloud-appstream-fleet-shusys-prv-default-scale-in-Alarm 

# VARIABLES 
accountId="931756137289"
accountName="hyoka-cloud"
fleet_name_1="shusys"
fleet_name_2="shusys-prv"
actionsEnabled="no"

# --alarm-actions 'arn:aws:sns:ap-northeast-1:505982390831:hyoka-cloud-sns-topic' \

# Target 1: shusys
# Scale-Out ------------------------------------------------------
aws cloudwatch put-metric-alarm \
--alarm-name 'Appstream2-'${accountName}'-appstream-fleet-'${fleet_name_1}'-default-scale-out-Alarm' \
--${acctionsEnabled}actions-enabled \
--alarm-actions 'arn:aws:sns:ap-northeast-1:505982390831:hyoka-cloud-sns-topic' \
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
--${acctionsEnabled}actions-enabled \
--alarm-actions 'arn:aws:sns:ap-northeast-1:505982390831:hyoka-cloud-sns-topic' \
--metrics '{"Id":"m1","MetricStat":{"Metric":{"Namespace":"AWS/AppStream","MetricName":"CapacityUtilization","Dimensions":[{"Name":"Fleet","Value":"'$fleet_name_1'"}]},"Period":120,"Stat":"Average"},"ReturnData":true,"AccountId":"'$accountId'"}' \
--evaluation-periods 10 \
--datapoints-to-alarm 10 \
--threshold 25.0 \
--comparison-operator "LessThanOrEqualToThreshold" \
--treat-missing-data 'notBreaching'
# ------------------------------------------------------------------

# Target 2: shusys-prv
# Scale-Out ------------------------------------------------------
aws cloudwatch put-metric-alarm \
--alarm-name 'Appstream2-'${accountName}'-appstream-fleet-'${fleet_name_2}'-default-scale-out-Alarm' \
--${acctionsEnabled}actions-enabled \
--alarm-actions 'arn:aws:sns:ap-northeast-1:505982390831:hyoka-cloud-sns-topic' \
--metrics '{"Id":"m1","MetricStat":{"Metric":{"Namespace":"AWS/AppStream","MetricName":"CapacityUtilization","Dimensions":[{"Name":"Fleet","Value":"'$fleet_name_2'"}]},"Period":60,"Stat":"Average"},"ReturnData":true,"AccountId":"'$accountId'"}' \
--evaluation-periods 3 \
--datapoints-to-alarm 3 \
--threshold 75.0 \
--comparison-operator "GreaterThanOrEqualToThreshold" \
--treat-missing-data 'notBreaching'
# ------------------------------------------------------------------

# Scale-In ------------------------------------------------------
aws cloudwatch put-metric-alarm \
--alarm-name 'Appstream2-'${accountName}'-appstream-fleet-'${fleet_name_2}'-default-scale-in-Alarm' \
--${acctionsEnabled}actions-enabled \
--alarm-actions 'arn:aws:sns:ap-northeast-1:505982390831:hyoka-cloud-sns-topic' \
--metrics '{"Id":"m1","MetricStat":{"Metric":{"Namespace":"AWS/AppStream","MetricName":"CapacityUtilization","Dimensions":[{"Name":"Fleet","Value":"'$fleet_name_2'"}]},"Period":120,"Stat":"Average"},"ReturnData":true,"AccountId":"'$accountId'"}' \
--evaluation-periods 10 \
--datapoints-to-alarm 10 \
--threshold 25.0 \
--comparison-operator "LessThanOrEqualToThreshold" \
--treat-missing-data 'notBreaching'
# ------------------------------------------------------------------

echo "All Done"
