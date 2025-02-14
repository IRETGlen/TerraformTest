# Environment
aws_account_id    = "864283695195"
region            = "ap-northeast-1"
environment       = "Production"
costcenter        = "TokyoKantei"
app_name          = "hyoka"
app_name_env_code = "hyoka-customer-1"

# Lambda Permissions
system_api_arn = "arn:aws:execute-api:ap-northeast-1:864283695195:guax6pzg15"
link_api_arn   = "arn:aws:execute-api:ap-northeast-1:864283695195:htuaigpf7k"

lambda_post_permission_group_system_api = [
  "GetTkyd",
  "GetTksd",
  "StoreTkyd",
  "StoreTksd",
  "DeleteBuild",
  "ActionRenkeiKeyEditFreeKey",
  "ActionRenkeiKeyEditRenkeiKey",
  "ActionRenkeiKeyDeleteBuild",
  "CreateCsv",
  "CheckLoadRenkeiKey",
  "CheckEditKey",
  "EditRenkeiKey",
  "EditFreeKey",
  "GetHistoryProspect",
  "GetHistoryAssessment",
  "ReviveBuild",
  "StartGetListCsv"
]

lambda_get_permission_group_system_api = [
  "GetTkyd",
  "GetTksd"
]