aws_account_id = "286325778687"
environment = "production"

region = "ap-northeast-1"

pipeline_name = "lambda-pipeline-deployment-2"

commit_respository_name = "datalake-lambda-repo-2"

vpc_id              = "vpc-07070b0ed0afa43be"
subnet_ids          = ["subnet-044ae6d88af71019a", "subnet-0d5d5cb2ebf5e36d9"]
security_group_ids  = ["sg-07388b36a5ceb1f5a"]

cloudformation_stack_name = "datalake-lambda-functions2"

SNSContact = "system-datalake-alert@kantei.co.jp"

apigateway_execution_url = "o6bgk1r973.execute-api.ap-northeast-1.amazonaws.com"