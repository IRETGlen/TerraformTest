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
  integration_http_method = "POST"//modified for prd only
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
