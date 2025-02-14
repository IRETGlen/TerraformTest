// ---------- Lambda IAM Role ----------
resource "aws_iam_role" "datanavi_lambda_role" {
  name = var.lambda_role_name
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}


// ---------- Attach IAM Policies ----------
resource "aws_iam_role_policy_attachment" "attach-lambdafullaccess" {
  role       = aws_iam_role.datanavi_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
}

resource "aws_iam_role_policy_attachment" "attach-lambdavpcaccess-executionrole" {
  role       = aws_iam_role.datanavi_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "attach-s3fullaccess" {
  role       = aws_iam_role.datanavi_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
// enhanced monitoring policy
resource "aws_iam_role_policy_attachment" "attach-cwlambdainsights-execuionrolepolicy" {
  role       = aws_iam_role.datanavi_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy"
}
// logging policy 
resource "aws_iam_role_policy_attachment" "attach-loggingpolicy" {
  role       = aws_iam_role.datanavi_lambda_role.name
  policy_arn = aws_iam_policy.function_logging_policy.arn
}

// ---------- Lambda Function ----------
data "archive_file" "sample"{
    type = "zip"
    output_path = "${path.module}/lambda_function_payload.zip"
    source {
        content = "hello"
        filename = "index.js"
    }
}

resource "aws_lambda_function" "pastmap_lambda" {
  filename      = data.archive_file.sample.output_path
  function_name = var.function_name
  role          = aws_iam_role.datanavi_lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"
  timeout       = 60
  memory_size   = 3008
  layers = [
      "arn:aws:lambda:ap-northeast-1:580247275435:layer:LambdaInsightsExtension:32"
  ]

  vpc_config {
    subnet_ids         = [data.terraform_remote_state.base_network.outputs.private_subnet1]
    security_group_ids = [data.terraform_remote_state.base_network.outputs.datanavi_stg_lambda_security_group]
  }

  environment {
    variables = {
      IMG_HEIGHT_TALL  = "2134px",
      IMG_HEIGHT_WIDE  = "1588px",
      IMG_WIDTH_TALL   = "1588px",
      IMG_WIDTH_WIDE   = "2134px"
      LOGLEVEL         = "INFO",
      MAP_TYPE         = "6XVb4mCi",
      RENDER_IDLE_TIME = "5000"
      ZOOM_LEVEL       = "438"
    }
  }
  tags = {
    Environment     = var.environment
    ServiceProvider = "Rackspace"
  }
}

// ---------- Lambda Permission for API Gatewway ----------
resource "aws_lambda_permission" "lambda_permission" {
  action        = "lambda:InvokeFunction"
  function_name = var.function_name //be careful! not to modify existing policy
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.pastmap_api.execution_arn}/*/GET/"
}



// ---------- Cloudwatch Log Group ----------
resource "aws_cloudwatch_log_group" "function_log_group" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 90
  lifecycle {
    prevent_destroy = false
  }
}

// ---------- Cloudwatch Logs Policy ----------
resource "aws_iam_policy" "function_logging_policy" {
  name   = var.logging_policy_name
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "arn:aws:logs:ap-northeast-1:${var.aws_account_id}:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:ap-northeast-1:${var.aws_account_id}:log-group:/aws/lambda/${var.function_name}:*"
            ]
        }
    ]
}
EOF
}