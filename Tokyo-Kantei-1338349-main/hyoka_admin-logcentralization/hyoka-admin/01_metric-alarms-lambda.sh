#!/bin/bash
echo "Setting Up Monitoring for hyoka_cloud"

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
    echo "variable is $var"
    aws cloudwatch put-metric-alarm \
    --alarm-name "hyoka-admin-lambda-${var}-error-high" \
    --actions-enabled \
    --alarm-actions 'arn:aws:sns:ap-northeast-1:505982390831:hyoka-admin-sns-topic' \
    --metric-name "Errors" \
    --namespace "AWS/Lambda" \
    --statistic "Sum" \
    --dimensions "Name=FunctionName,Value=${var}" \
    --period 60 \
    --evaluation-periods 15 \
    --datapoints-to-alarm 15 \
    --threshold 5.0 \
    --comparison-operator "GreaterThanOrEqualToThreshold" \
    --treat-missing-data 'notBreaching'

done

echo "All Done"
