#!/bin/bash
echo "Setting Up Monitoring for hyoka_customer_1"
echo "Monitoring Setup for Log Alarm - Lambda"

# --- Output is 50 Lambda Log Alarms below
# TaskTimedOut
# MaxMemoryUsed

# VARIABLES 
source variables.sh

for var in "${lambda_list[@]}"
do
    echo "function is ${var}'"
    # MaxMemeoryUsed ------------------------------------------------------
    threshold=`aws lambda get-function --function-name ${var} --query Configuration.MemorySize`

    aws cloudwatch put-metric-alarm \
    --alarm-name "${accountName}-lambdalogs-$var-maxmemoryused-high" \
    --${actionsEnabled}actions-enabled \
    --alarm-actions "arn:aws:sns:ap-northeast-1:505982390831:${snsTopic}" \
    --metrics '{"Id":"m1","MetricStat":{"Metric":{"Namespace":"LambdaLogMetrics","MetricName":"'$var'/MaxMemoryUsed"},"Period":60,"Stat":"Sum"},"ReturnData":true,"AccountId":"'$accountId'"}' \
    --evaluation-periods 15 \
    --datapoints-to-alarm 15 \
    --threshold $threshold \
    --comparison-operator "GreaterThanOrEqualToThreshold" \
    --treat-missing-data 'notBreaching'
    # ------------------------------------------------------------------

    # TaskTimedOut ------------------------------------------------------
    aws cloudwatch put-metric-alarm \
    --alarm-name "${accountName}-lambdalogs-$var-tasktimedout-high" \
    --${actionsEnabled}actions-enabled \
    --alarm-actions "arn:aws:sns:ap-northeast-1:505982390831:${snsTopic}" \
    --metrics '{"Id":"m1","MetricStat":{"Metric":{"Namespace":"LambdaLogMetrics","MetricName":"'$var'/TaskTimedOut"},"Period":60,"Stat":"Sum"},"ReturnData":true,"AccountId":"'$accountId'"}' \
    --evaluation-periods 15 \
    --datapoints-to-alarm 15 \
    --threshold 5.0 \
    --comparison-operator "GreaterThanOrEqualToThreshold" \
    --treat-missing-data 'notBreaching'
    # ------------------------------------------------------------------    
done

echo "All Done"