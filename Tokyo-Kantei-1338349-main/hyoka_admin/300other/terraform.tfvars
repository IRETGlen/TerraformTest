######## Environment ########
aws_account_id    = "505982390831" 
region            = "ap-northeast-1"
environment       = "Production"
costcenter        = "TokyoKantei"
app_name          = "hyoka"
app_env           = "admin"
app_name_env_code = "hyoka-admin"


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
