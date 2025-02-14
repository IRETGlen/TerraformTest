# Some steps in this layer need to be executed manually.

# 1. AppStream Fleet Scaling Policy
# 2. Associate VPC Endpoint to SYSTEM API
aws apigateway update-rest-api \
    --rest-api-id {rest api id} \
    --patch-operations "op='add',path='/endpointConfiguration/vpcEndpointIds',value='{vpcendpoint id}'" \
    --region ap-northeast-1

# check if the above with command below 
aws apigateway get-rest-api --rest-api-id {restapi id}
