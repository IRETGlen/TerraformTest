######## Environment ########
aws_account_id    = "864283695195" 
region            = "ap-northeast-1"
environment       = "Production"
costcenter        = "TokyoKantei"
app_name          = "hyoka"
app_env           = "customer-1"
app_name_env_code = "hyoka-customer-1"


######## S3 Bucket ########
bucket_name = "list-csv-output-destination"


######## CloudWatch Alarm ########
systemapi_name = "system_api"
linkapi_name = "link_api"
lambda_list = [
    "DeleteBuild",
    "ActionRenkeiKeyEditFreeKey",
    "ActionRenkeiKeyEditRenkeiKey", 
    "ActionRenkeiKeyEditOptionalItem", 
    "ActionRenkeiKeyDeleteBuild",
    "CheckLoadRenkeiKey",
    "ReviveBuild",
    "CreateCsv",
    "CreateListCsvProspect",
    "CheckEditKey",
    "EditRenkeiKey",
    "EditFreeKey",
    "GetHistoryProspect",
    "GetHistoryAssessment",
    "StartGetListCsvProspect",
    "GetTkyd",
    "StoreTkyd",
    "GetTksd",
    "StoreTksd",
    "SearchAssessmentAndProspect",
    "CreateListCsv",
    "CombineListCsv",
    "StartGetListCsv",
    "GetCSVURL",
    "pass-large-payload"
]
