#!/bin/bash
echo "Monitoring Setup for Metric Alarm - Lambda Error"

# --- Output is 25 Lambda Alarms below
# -- Metric Alarm - Lambda (25)
# Metric: Error 

# VARIABLES 
accountId="931756137289"
accountName="hyoka-cloud"
acctionsEnabled=""
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

# --- Metric Alarm - Lambda Error (25)
for var in "${lambda_list[@]}"
do
    echo "variable is $var"
    metrics_math='{"Id":"m1","MetricStat":{"Metric":{"Namespace":"AWS/Lambda","MetricName":"Errors","Dimensions":[{"Name":"FunctionName","Value":"'${var}'"},{"Name":"Resource","Value":"'$var'"}]},"Period":60,"Stat":"Sum"},"ReturnData":true,"AccountId":"'$accountId'"}'
    aws cloudwatch put-metric-alarm \
    --alarm-name "${accountName}-lambda-${var}-error-high" \
    --${acctionsEnabled}actions-enabled \
    --alarm-actions 'arn:aws:sns:ap-northeast-1:505982390831:hyoka-cloud-sns-topic' \
    --metrics $metrics_math \
    --evaluation-periods 15 \
    --datapoints-to-alarm 15 \
    --threshold 5.0 \
    --comparison-operator "GreaterThanOrEqualToThreshold" \
    --treat-missing-data 'notBreaching'
done

echo "All Done"