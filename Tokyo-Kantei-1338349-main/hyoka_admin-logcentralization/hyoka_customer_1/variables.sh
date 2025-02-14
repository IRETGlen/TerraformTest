export accountId="864283695195"
export accountName="hyoka-customer-1"
export snsTopic="hyoka-customer-1-sns-topic"
export actionsEnabled=""
export fleet_name_1="hyoka-customer-1-appstream-fleet"
export rds_name="hyoka-customer-1-aurora-rds"
export db_identifier="hyoka-customer-1-aurora-rds"
export lambda_list=(
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