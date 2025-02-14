####################################################################
# --- Lambda Function to create pull request and trigger pipeline 2
#    --- 1. IAM Role
#    --- 2. IAM Policy 
#    --- 3. zip file
#    --- 4. Lambda Function
####################################################################

resource "aws_iam_role" "lambda_role" {
name   = "${var.app_name_env_code}-lambda-createpullrequest-role"
assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "lambda.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_policy" "iam_policy_for_lambda" {
 
 name         = "${var.app_name_env_code}-lambda-createpullrequest-policy"
 path         = "/"
 description  = "AWS IAM Policy for managing aws lambda role"
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
                "arn:aws:logs:ap-northeast-1:${var.aws_account_id}:log-group:/aws/lambda/${var.lambda_name}:*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "codecommit:CreatePullRequest"
            ],
            "Resource": [
                "arn:aws:codecommit:ap-northeast-1:${var.aws_account_id}:${var.commit_respository_name}*"
            ]
        },
        {
            "Action": [
                "codepipeline:PutJobSuccessResult",
                "codepipeline:PutJobFailureResult"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }        
    ]
}
EOF
}
 
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
 role        = aws_iam_role.lambda_role.name
 policy_arn  = aws_iam_policy.iam_policy_for_lambda.arn
}
 
data "archive_file" "zip_the_python_code" {
type        = "zip"
source_dir  = "${path.module}/python/"
output_path = "${path.module}/python/create-pullrequest.zip"
}
 
resource "aws_lambda_function" "terraform_lambda_func" {
filename                       = "${path.module}/python/create-pullrequest.zip"
function_name                  = var.lambda_name
role                           = aws_iam_role.lambda_role.arn
handler                        = "index.lambda_handler"
runtime                        = "python3.9"
depends_on                     = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
}