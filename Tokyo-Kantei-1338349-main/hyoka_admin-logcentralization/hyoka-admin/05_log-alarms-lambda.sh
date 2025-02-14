#!/bin/bash
echo "Setting Up Monitoring for hyoka_cloud"
echo "Monitoring Setup for Log Alarm - Lambda"

# --- Output is 50 Lambda Log Alarms below
# TaskTimedOut
# MaxMemoryUsed

# VARIABLES 
accountId="931756137289"
accountName="hyoka-admin"

lambda_list=(
    GetTkyd
    StoreTkyd
    GetTksd
    StoreTksd
    DeleteBuild
    SearchAssessmentAndProspect
    ActionRenkeiKeyEditFreeKey
    ActionRenkeiKeyEditRenkeiKey
    ActionRenkeiKeyEditOptionalItem
    ActionRenkeiKeyDeleteBuild
    CreateCsv
    CreateListCsv
    CreateListCsvProspect
    CheckLoadRenkeiKey
    CheckEditKey
    CombineListCsv
    EditRenkeiKey
    EditFreeKey
    GetHistoryProspect
    GetHistoryAssessment
    ReviveBuild
    StartGetListCsv
    StartGetListCsvProspect
    GetCSVURL
    pass-large-payload
)

for var in "${lambda_list[@]}"
do
    echo "function is '${var}'"
    # MaxMemeoryUsed ------------------------------------------------------
    threshold=`aws lambda get-function --function-name $var --query Configuration.MemorySize`

    aws cloudwatch put-metric-alarm \
    --alarm-name ''${accountName}'-lambdalogs-'$var'-maxmemoryused-high' \
    --${acctionsEnabled}actions-enabled \
    --alarm-actions 'arn:aws:sns:ap-northeast-1:505982390831:hyoka-admin-sns-topic' \
    --metric-name ''${var}'/MaxMemoryUsed' \
    --namespace 'LambdaLogMetrics' \
    --statistic 'Sum' \
    --period 60 \
    --evaluation-periods 15 \
    --datapoints-to-alarm 15 \
    --threshold $threshold \
    --comparison-operator "GreaterThanOrEqualToThreshold" \
    --treat-missing-data 'notBreaching'
    # ------------------------------------------------------------------

    # TaskTimedOut ------------------------------------------------------
    aws cloudwatch put-metric-alarm \
    --alarm-name ''${accountName}'-lambdalogs-'$var'-tasktimedout-high' \
    --${acctionsEnabled}actions-enabled \
    --alarm-actions 'arn:aws:sns:ap-northeast-1:505982390831:hyoka-admin-sns-topic' \
    --metric-name ''${var}'/TaskTimedOut' \
    --namespace 'LambdaLogMetrics' \
    --statistic 'Sum' \
    --period 60 \
    --evaluation-periods 15 \
    --datapoints-to-alarm 15 \
    --threshold 5.0 \
    --comparison-operator "GreaterThanOrEqualToThreshold" \
    --treat-missing-data 'notBreaching'
    # ------------------------------------------------------------------    
done

echo "All Done"