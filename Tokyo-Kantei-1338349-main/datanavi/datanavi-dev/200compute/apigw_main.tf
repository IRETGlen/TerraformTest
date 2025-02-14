// ---------- REST API ----------
resource "aws_api_gateway_rest_api" "pastmap_api" {
  name        = var.api_name
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}


// ---------- METHOD ----------
resource "aws_api_gateway_method" "GET_method" {
  rest_api_id   = aws_api_gateway_rest_api.pastmap_api.id
  resource_id   = aws_api_gateway_rest_api.pastmap_api.root_resource_id
  http_method   = "GET"
  authorization = "NONE"
  api_key_required = true
}


// ---------- METHOD RESPONSE ---------
resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.pastmap_api.id
  resource_id = aws_api_gateway_rest_api.pastmap_api.root_resource_id
  http_method = aws_api_gateway_method.GET_method.http_method
  status_code = "200"
  response_models = {
    "application/json": "Empty"
  }
}


// ---------- LAMBDA INTEGRATION ----------
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.pastmap_api.id
  resource_id             = aws_api_gateway_rest_api.pastmap_api.root_resource_id
  http_method             = "GET"
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.pastmap_lambda.invoke_arn
}


// ---------- RESOURCE POLICY ----------
resource "aws_api_gateway_rest_api_policy" "resource_policy" {
  rest_api_id = aws_api_gateway_rest_api.pastmap_api.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "execute-api:Invoke",
      "Resource": "${aws_api_gateway_rest_api.pastmap_api.execution_arn}/*/*/*"
    },
    {
      "Effect": "Deny",
      "Principal": "*",
      "Action": "execute-api:Invoke",
      "Resource": "${aws_api_gateway_rest_api.pastmap_api.execution_arn}/*/*/*",
      "Condition": {
        "NotIpAddress": {
          "aws:SourceIp": [
            "203.180.246.183",
            "203.180.246.184"
          ]
        }
      }
    }
  ]
}
EOF
}


// ---------- USAGE PLAN ----------
# resource "aws_api_gateway_usage_plan" "usage_plan" {
#   name = var.usage_plan_name
# }


// ---------- API Gateway IAM Role ----------
resource "aws_iam_role" "api_gateway_account_role" {
  name = "APIGatewayRole"
  assume_role_policy = <<EOF
{
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "apigateway.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  }
EOF
}


// ---------- API Gateway IAM Policy ----------
resource "aws_iam_role_policy" "api_gateway_cloudwatch_policy" {
  name = "APIGateway-CloudWatch-Policy"
  role = aws_iam_role.api_gateway_account_role.id
  policy = <<EOF
{
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents",
          "logs:GetLogEvents",
          "logs:FilterLogEvents"
        ],
        "Resource" : "*"
      }
    ]
  }
EOF
}

resource "aws_api_gateway_account" "api_gateway_account" {
  cloudwatch_role_arn = aws_iam_role.api_gateway_account_role.arn
}