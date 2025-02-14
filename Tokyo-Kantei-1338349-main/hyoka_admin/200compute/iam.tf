######### IAM User ##########

# -----------------------------------------------
# IAM User: shusys-sv
# Policies: 
# --- AmazonCognitoPowerUser
# --- PolicyStatementToAllowUserToPassOneSpecificRole
# -----------------------------------------------

resource "aws_iam_user" "hyoka_shusys-sv" {
  name = "shusys-sv"
}

// ---------- Custom IAM Policy ----------
// PolicyStatementToAllowUserToPassOneSpecificRole ----------
resource "aws_iam_policy" "iamuser_PolicyStatementToAllowUserToPassOneSpecificRole_policy" {
  name   = "PolicyStatementToAllowUserToPassOneSpecificRole"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "iam:PassRole"
            ],
            "Resource": "arn:aws:iam::${var.aws_account_id}:role/CloudWatchLogsRole"
        }
    ]
}
EOF
}

// ---------- Attach Custom IAM Policy ----------
resource "aws_iam_user_policy_attachment" "attach-PolicyStatementToAllowUserToPassOneSpecificRole_policy" {
  user       = aws_iam_user.hyoka_shusys-sv.name
  policy_arn = aws_iam_policy.iamuser_PolicyStatementToAllowUserToPassOneSpecificRole_policy.arn
}

// ---------- Attach AWS Managed IAM Policies ----------
resource "aws_iam_user_policy_attachment" "attach-AmazonCognitoPowerUser-policy" {
  user       = aws_iam_user.hyoka_shusys-sv.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonCognitoPowerUser"
}


######### Lambda IAM Role ##########

# -----------------------------------------------
# 1. Lambda Role: shusys-step-lambda-role
# Policies: 
# --- shusys-CloudWatchLogsDeliveryFullAccessPolicy
# --- shusys-step-lambda-policy
# --- shusys-step-xray-policy
# -----------------------------------------------

// ---------- Lambda IAM Role ----------
resource "aws_iam_role" "hyoka_shusys_step_lambda_role" {
  name = var.iam_role_shusys_step_lambda
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "states.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

// ---------- Lambda Custom IAM Policies ----------
// shusys-CloudWatchLogsDeliveryFullAccessPolicy ----------
resource "aws_iam_policy" "function_shusys_CloudWatchLogsDeliveryFullAccessPolicy" {
  name   = "shusys-CloudWatchLogsDeliveryFullAccessPolicy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogDelivery",
                "logs:PutResourcePolicy",
                "logs:DescribeLogGroups",
                "logs:UpdateLogDelivery",
                "logs:DeleteLogDelivery",
                "logs:DescribeResourcePolicies",
                "logs:GetLogDelivery",
                "logs:ListLogDeliveries"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

// shusys-step-lambda-policy ----------
resource "aws_iam_policy" "function_shusys_step_lambda_policy" {
  name   = "shusys-step-lambda-policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "lambda:InvokeFunction",
            "Resource": [
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:ActionRenkeiKeyDeleteBuild:*",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:pass-large-payload:*",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:ActionRenkeiKeyEditOptionalItem:*",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:ActionRenkeiKeyEditFreeKey:*",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:ActionRenkeiKeyEditRenkeiKey:*",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:CheckLoadRenkeiKey:*",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:CreateListCsv:*",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:CombineListCsv:*",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:StartGetListCsv:*",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:CreateListCsvProspect:*",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:StartGetListCsvProspect:*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": "lambda:InvokeFunction",
            "Resource": [
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:ActionRenkeiKeyDeleteBuild",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:pass-large-payload",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:ActionRenkeiKeyEditOptionalItem",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:ActionRenkeiKeyEditFreeKey",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:ActionRenkeiKeyEditRenkeiKey",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:CheckLoadRenkeiKey",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:CreateListCsv",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:CombineListCsv",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:StartGetListCsv",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:CreateListCsvProspect",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:StartGetListCsvProspect"
            ]
        }
    ]
}
EOF
}

// shusys-step-xray-policy ----------
resource "aws_iam_policy" "function_shusys_step_xray_policy" {
  name   = "shusys-step-xray-policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "xray:PutTelemetryRecords",
                "xray:GetSamplingRules",
                "xray:GetSamplingTargets",
                "xray:PutTraceSegments"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

// ---------- Attach Custom IAM Policies ----------
resource "aws_iam_role_policy_attachment" "attach-CloudWatchLogsDeliveryFullAccessPolicy" {
  role       = aws_iam_role.hyoka_shusys_step_lambda_role.name
  policy_arn = aws_iam_policy.function_shusys_CloudWatchLogsDeliveryFullAccessPolicy.arn
}

resource "aws_iam_role_policy_attachment" "attach-shusys-step-lambda-policy" {
  role       = aws_iam_role.hyoka_shusys_step_lambda_role.name
  policy_arn = aws_iam_policy.function_shusys_step_lambda_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach-shusys-step-xray-policy" {
  role       = aws_iam_role.hyoka_shusys_step_lambda_role.name
  policy_arn = aws_iam_policy.function_shusys_step_xray_policy.arn
}



# -----------------------------------------------
# 2. Lambda Role: lambda-role 
# Policies: 
# --- access_to_secrets
# --- getParam
# --- AWSXRayDaemonWriteAccess
# --- AWSLambdaBasicExecutionRole
# --- AWSLambdaVPCAccessExecutionRole
# --- AWSStepFunctionsFullAccess
# --- AmazonS3ObjectLambdaExecutionRolePolicy
# -----------------------------------------------

// ---------- Lambda IAM Role ----------
resource "aws_iam_role" "hyoka_lambda_role" {
  name = var.iam_role_lambda
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

// ---------- Lambda Custom IAM Policies ----------
// Secrets Access Policy ----------
resource "aws_iam_policy" "function_access_to_secrets_policy" {
  name   = "access_to_secrets"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetResourcePolicy",
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret",
        "secretsmanager:ListSecretVersionIds"              
      ],
      "Resource": [
        "arn:aws:secretsmanager:ap-northeast-1:${var.aws_account_id}:secret:testSecrets-SWQRdR"
      ]
    }
  ]
}
EOF
}

// GetParam Policy ----------
resource "aws_iam_policy" "function_getParam_policy" {
  name   = "getParam"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": [
        "kms:Decrypt",
        "ssm:GetParameter"
      ],
      "Resource": [
        "arn:aws:ssm:*:${var.aws_account_id}:parameter/*",
        "arn:aws:kms:*:${var.aws_account_id}:key/*"
      ]
    }
  ]
}
EOF
}


// ---------- Attach AWS Managed IAM Policies ----------
resource "aws_iam_role_policy_attachment" "attach-xraydaemon-writeaccess" {
  role       = aws_iam_role.hyoka_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
}

resource "aws_iam_role_policy_attachment" "attach-lambda-basic-executionrole" {
  role       = aws_iam_role.hyoka_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "attach-lambda-vpcaccess-executionrole" {
  role       = aws_iam_role.hyoka_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "attach-stepfunctions-fullaccess" {
  role       = aws_iam_role.hyoka_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSStepFunctionsFullAccess"
}

resource "aws_iam_role_policy_attachment" "attach-s3object-lambda-execution-rolepolicy" {
  role       = aws_iam_role.hyoka_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonS3ObjectLambdaExecutionRolePolicy"
}

// ---------- Attach Custom IAM Policies ----------
resource "aws_iam_role_policy_attachment" "attach-getParam-policy" {
  role       = aws_iam_role.hyoka_lambda_role.name
  policy_arn = aws_iam_policy.function_getParam_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach-access_to_secrets-policy" {
  role       = aws_iam_role.hyoka_lambda_role.name
  policy_arn = aws_iam_policy.function_access_to_secrets_policy.arn
}



# -----------------------------------------------
# 3. Service Role: service-role/GetCSVURL_role
# Policies: 
# --- AWSLambdaBasicExecutionRole-0958024c-cb5b-4a57-9092-9d54cec22a54
# --- AWSLambdaS3ExecutionRole-bd6a761f-8f50-4249-ab5c-de246f484f06
# --- getParam
# --- AmazonS3FullAccess
# -----------------------------------------------

// ---------- Lambda IAM Role ----------
resource "aws_iam_role" "hyoka_GetCSVURL_role" {
  name = var.iam_role_get_csv_url
  path = "/service-role/"
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

// ---------- Lambda Custom IAM Policies ----------
// AWSLambdaBasicExecutionRole ----------
resource "aws_iam_policy" "function_AWSLambdaBasicExecutionRole_policy" {
  name   = "AWSLambdaBasicExecutionRole-${var.aws_account_id}"
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
                "arn:aws:logs:ap-northeast-1:${var.aws_account_id}:log-group:/aws/lambda/GetCSVURL:*"
            ]
        }
    ]
}
EOF
}

// AWSLambdaS3ExecutionRole ----------
resource "aws_iam_policy" "function_AWSLambdaS3ExecutionRole_policy" {
  name   = "AWSLambdaS3ExecutionRole-${var.aws_account_id}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": "arn:aws:s3:::*"
        }
    ]
}
EOF
}

// ---------- Attach Custom IAM Policies ----------
resource "aws_iam_role_policy_attachment" "attach-AWSLambdaBasicExecutionRole-policy" {
  role       = aws_iam_role.hyoka_GetCSVURL_role.name
  policy_arn = aws_iam_policy.function_AWSLambdaBasicExecutionRole_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach-AWSLambdaS3ExecutionRole-policy" {
  role       = aws_iam_role.hyoka_GetCSVURL_role.name
  policy_arn = aws_iam_policy.function_AWSLambdaS3ExecutionRole_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach-getParam-policy_to_GetCSVRole" {
  role       = aws_iam_role.hyoka_GetCSVURL_role.name
  policy_arn = aws_iam_policy.function_getParam_policy.arn
}

// ---------- Attach AWS Managed IAM Policies ----------
resource "aws_iam_role_policy_attachment" "attach-amazons3fullaccess-policy" {
  role       = aws_iam_role.hyoka_GetCSVURL_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}



# -----------------------------------------------
# 4. API Lambda Role: shusys-API-Lambda-role
# Policies: 
# --- shusys-api-lambda-policy
# --- AmazonAPIGatewayPushToCloudWatchLogs
# -----------------------------------------------

// ---------- Lambda IAM Role ----------
resource "aws_iam_role" "hyoka_shusys_API_Lambda_role" {
  name = var.iam_role_shusys_api_lambda
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

// ---------- Lambda Custom IAM Policies ----------
// shusys-api-lambda-policy ----------
resource "aws_iam_policy" "function_shusys_api_lambda_policy" {
  name   = "shusys-api-lambda-policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "lambda:InvokeFunction",
            "Resource": [
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:GetCSVURL",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:CheckEditKey",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:CheckLoadRenkeiKey",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:CreateCsv",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:DeleteBuild",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:EditFreeKey",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:EditRenkeiKey",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:GetHistoryAssessment",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:GetHistoryProspect",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:GetTksd",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:GetTkyd",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:ReviveBuild",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:SearchAssessmentAndProspect",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:StoreTksd",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:StoreTkyd"
            ]
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "lambda:InvokeFunction",
            "Resource": [
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:GetCSVURL:*",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:CheckEditKey:*",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:CheckLoadRenkeiKey:*",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:CreateCsv:*",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:DeleteBuild:*",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:EditFreeKey:*",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:EditRenkeiKey:*",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:GetHistoryAssessment:*",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:GetHistoryProspect:*",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:GetTksd:*",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:GetTkyd:*",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:ReviveBuild:*",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:SearchAssessmentAndProspect:*",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:StoreTksd:*",
                "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:StoreTkyd:*"
            ]
        }
    ]
}
EOF
}

// ---------- Attach Custom IAM Policies ----------
resource "aws_iam_role_policy_attachment" "attach-function_shusys_api_lambda_policy-policy" {
  role       = aws_iam_role.hyoka_shusys_API_Lambda_role.name
  policy_arn = aws_iam_policy.function_shusys_api_lambda_policy.arn
}

// ---------- Attach AWS Managed IAM Policies ----------
resource "aws_iam_role_policy_attachment" "attach-AmazonAPIGatewayPushToCloudWatchLogs-policy" {
  role       = aws_iam_role.hyoka_shusys_API_Lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}


# -----------------------------------------------
# 5. API StepFunctions Role: API-StepFunctions-role
# Policies: 
# --- AmazonAPIGatewayPushToCloudWatchLogs
# --- AWSStepFunctionsFullAccess
# -----------------------------------------------

// ---------- Lambda IAM Role ----------
resource "aws_iam_role" "hyoka_API_StepFunctions_role" {
  name = var.iam_role_api_stepfunctions
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

// ---------- Attach AWS Managed IAM Policies ----------
resource "aws_iam_role_policy_attachment" "attach-AmazonAPIGatewayPushToCloudWatchLogs-policy_to_APIStepFunctionsRole" {
  role       = aws_iam_role.hyoka_API_StepFunctions_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

resource "aws_iam_role_policy_attachment" "attach-AWSStepFunctionsFullAccess-policy" {
  role       = aws_iam_role.hyoka_API_StepFunctions_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSStepFunctionsFullAccess"
}


# -----------------------------------------------
# 6. Lambda Role: CloudWatchLogsDeliveryFullAccessPolicy
# Policies: 
# --- shusys-CloudWatchLogsDeliveryFullAccessPolicy
# --- shusys-step-lambda-policy
# --- shusys-step-xray-policy
# -----------------------------------------------