// ---------- REST API ----------
resource "aws_api_gateway_rest_api" "system_api" {
  name        = var.system_api_name

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

// ---------- REST API ----------
resource "aws_api_gateway_rest_api" "link_api" {
  name        = var.link_api_name

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

// ---------- API Gateway CWLogs IAM Role ----------
resource "aws_iam_role" "hyoka_CloudWatch_Logs_for_APIGateway" {
  name = "CloudWatch-Logs-for-APIGateway"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": "apigateway.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

// ---------- CloudWatch Log Role for API GW ----------
resource "aws_api_gateway_account" "api_gateway_account" {
  cloudwatch_role_arn = aws_iam_role.hyoka_CloudWatch_Logs_for_APIGateway.arn
}

// ---------- Attach AWS Managed IAM Policies ----------
resource "aws_iam_role_policy_attachment" "attach-hyoka_CloudWatch_Logs_for_APIGateway" {
  role       = aws_iam_role.hyoka_CloudWatch_Logs_for_APIGateway.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}
