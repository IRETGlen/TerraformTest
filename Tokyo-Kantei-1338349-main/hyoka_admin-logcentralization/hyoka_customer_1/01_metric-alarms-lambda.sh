#!/bin/bash
echo "Monitoring Setup for Metric Alarm - Lambda Error"

# --- Output is 25 Lambda Alarms below
# -- Metric Alarm - Lambda (25)
# Metric: Error 

# VARIABLES 
source variables.sh

# --- Metric Alarm - Lambda Error (25)
for var in "${lambda_list[@]}"
do
    echo "variable is $var"
    metrics_math='{"Id":"m1","MetricStat":{"Metric":{"Namespace":"AWS/Lambda","MetricName":"Errors","Dimensions":[{"Name":"FunctionName","Value":"'${var}'"},{"Name":"Resource","Value":"'$var'"}]},"Period":60,"Stat":"Sum"},"ReturnData":true,"AccountId":"'$accountId'"}'
    aws cloudwatch put-metric-alarm \
    --alarm-name "${accountName}-lambda-${var}-error-high" \
    --${actionsEnabled}actions-enabled \
    --alarm-actions "arn:aws:sns:ap-northeast-1:505982390831:${snsTopic}" \
    --metrics $metrics_math \
    --evaluation-periods 15 \
    --datapoints-to-alarm 15 \
    --threshold 5.0 \
    --comparison-operator "GreaterThanOrEqualToThreshold" \
    --treat-missing-data 'notBreaching'
done

echo "All Done"