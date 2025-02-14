####################################################################
# --- IAM Roles
#    --- 1. Event Bridge IAM Role
#    --- 2. CloudFormation IAM Role
#    --- 3. Code Pipeline IAM Role
#    --- 4. Code Source IAM Role
#    --- 5. Code Build IAM Role
#    --- 6. AWSCloudFormationStackSetAdministrationRole
####################################################################


### 1. Event Bridge IAM Role ###

resource "aws_iam_role" "lambda_event_bus_Role" {
  name               = var.eventbridge_iam_role
  assume_role_policy = data.aws_iam_policy_document.event_bus_assume_role.json
}

data "aws_iam_policy_document" "event_bus_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "event_bus_invoke_remote_event_bus" {
  statement {
    effect    = "Allow"
    actions   = ["codepipeline:StartPipelineExecution"]
    resources = ["${aws_codepipeline.codepipeline.arn}","${aws_codepipeline.codepipeline_prd.arn}"]
  }
}

resource "aws_iam_policy" "event_bus_invoke_remote_event_bus" {
  name   = "hyoka_event_bus_invoke_remote_event_bus"
  policy = data.aws_iam_policy_document.event_bus_invoke_remote_event_bus.json
}

resource "aws_iam_role_policy_attachment" "event_bus_invoke_remote_event_bus" {
  role       = aws_iam_role.lambda_event_bus_Role.name
  policy_arn = aws_iam_policy.event_bus_invoke_remote_event_bus.arn
}


## IAM Role Definitions ##


### 2. Cloudformation IAM Role ###

resource "aws_iam_role" "cfn_lambda_deploy_role" {
  name               = var.cloudformation_iam_role
  assume_role_policy = data.aws_iam_policy_document.cfn_assume_role.json
}

data "aws_iam_policy_document" "cfn_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudformation.amazonaws.com"]
    }
#    principals {
#      type        = "AWS"
#      identifiers = ["arn:aws:iam::${var.aws_account_id}s:root"]
#    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "cfn_role_policy" {
  statement {
    effect    = "Allow"
    actions   = [
      "kms:GenerateRandom",
      "events:EnableRule",
      "events:PutRule",
      "iam:CreateRole",
      "iam:AttachRolePolicy",
      "iam:PutRolePolicy",
      "kms:DescribeCustomKeyStores",
      "kms:DeleteCustomKeyStore",
      "iam:PassRole",
      "iam:DetachRolePolicy",
      "events:ListRuleNamesByTarget",
      "kms:UpdateCustomKeyStore",
      "iam:DeleteRolePolicy",
      "cloudformation:UpdateStack",
      "kms:CreateKey",
      "events:ListRules",
      "events:RemoveTargets",
      "kms:ConnectCustomKeyStore",
      "cloudformation:DescribeStacks",
      "cloudformation:CreateChangeSet",
      "cloudformation:ExecuteChangeSet",
      "events:ListTargetsByRule",
      "events:DisableRule",
      "sns:*",
      "events:PutEvents",
      "iam:GetRole",
      "events:DescribeRule",
      "apigateway:*",
      "iam:DeleteRole",
      "s3:GetBucketVersioning",
      "kms:CreateCustomKeyStore",
      "events:TestEventPattern",
      "events:PutPermission",
      "events:DescribeEventBus",
      "kms:ListKeys",
      "s3:GetObject",
      "events:TagResource",
      "events:PutTargets",
      "events:DeleteRule",
      "cloudformation:CreateStack",
      "kms:ListAliases",
      "lambda:*",
      "events:ListTagsForResource",
      "kms:DisconnectCustomKeyStore",
      "events:RemovePermission",
      "iam:GetRolePolicy",
      "s3:GetObjectVersion",
      "events:UntagResource",
      "ec2:*"
    ]
    resources = ["*"]
  }
  statement {
    effect    = "Allow"
    actions   = [
                "ssm:GetParameter*",
                "kms:*"
    ]
    resources = [
        "arn:aws:kms:*:${var.aws_account_id}:alias/*",
        "arn:aws:kms:*:${var.aws_account_id}:key/*",
        "arn:aws:ssm:*:${var.aws_account_id}:parameter/*"
    ]
  }
}

resource "aws_iam_policy" "cfn_deploy_role_policy" {
  name   = "cfn_deploy_role_policy2"
  policy = data.aws_iam_policy_document.cfn_role_policy.json
}

resource "aws_iam_role_policy_attachment" "cfn_deploy_role_policy" {
  role       = aws_iam_role.cfn_lambda_deploy_role.name
  policy_arn = aws_iam_policy.cfn_deploy_role_policy.arn
}


### 3. Code Pipeline IAM Role ###

resource "aws_iam_role" "codepipeline_role" {
  name               = var.codepipeline_iam_role
  assume_role_policy = data.aws_iam_policy_document.pipeline_assume_role.json
}

data "aws_iam_policy_document" "pipeline_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = [
        "codepipeline.amazonaws.com",
        "cloudformation.amazonaws.com"
        ]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "codepipeline_policy" {
  statement {
    effect = "Allow"
    actions = [
                "appconfig:StartDeployment",
                "opsworks:DescribeStacks",
                "states:DescribeStateMachine",
                "rds:*",
                "devicefarm:GetRun",
                "cloudformation:CreateChangeSet",
                "autoscaling:*",
                "codebuild:BatchGetBuilds",
                "servicecatalog:ListProvisioningArtifacts",
                "devicefarm:ScheduleRun",
                "devicefarm:ListDevicePools",
                "codestar-connections:UseConnection",
                "cloudformation:UpdateStack",
                "servicecatalog:DescribeProvisioningArtifact",
                "cloudformation:DescribeChangeSet",
                "cloudformation:ExecuteChangeSet",
                "devicefarm:ListProjects",
                "sns:*",
                "lambda:ListFunctions",
                "lambda:InvokeFunction",
                "codedeploy:RegisterApplicationRevision",
                "cloudformation:*",
                "opsworks:DescribeDeployments",
                "devicefarm:CreateUpload",
                "cloudformation:DescribeStacks",
                "codecommit:GetUploadArchiveStatus",
                "states:DescribeExecution",
                "cloudwatch:*",
                "codecommit:GetRepository",
                "cloudformation:DeleteStack",
                "opsworks:DescribeInstances",
                "ecr:DescribeImages",
                "ecs:*",
                "ec2:*",
                "codebuild:StartBuild",
                "cloudformation:ValidateTemplate",
                "opsworks:DescribeApps",
                "opsworks:UpdateStack",
                "codebuild:BatchGetBuildBatches",
                "codedeploy:CreateDeployment",
                "codedeploy:GetApplicationRevision",
                "codedeploy:GetDeploymentConfig",
                "servicecatalog:CreateProvisioningArtifact",
                "sqs:*",
                "cloudformation:DeleteChangeSet",
                "codecommit:GetCommit",
                "servicecatalog:DeleteProvisioningArtifact",
                "kms:CreateKey",
                "codedeploy:GetApplication",
                "cloudformation:SetStackPolicy",
                "codecommit:UploadArchive",
                "s3:*",
                "appconfig:GetDeployment",
                "elasticloadbalancing:*",
                "codecommit:CancelUploadArchive",
                "devicefarm:GetUpload",
                "appconfig:StopDeployment",
                "kms:ListKeys",
                "elasticbeanstalk:*",
                "opsworks:UpdateApp",
                "opsworks:CreateDeployment",
                "cloudformation:CreateStack",
                "servicecatalog:UpdateProduct",
                "codecommit:GetBranch",
                "kms:ListAliases",
                "codebuild:StartBuildBatch",
                "codedeploy:GetDeployment",
                "states:StartExecution",
                "opsworks:DescribeCommands"
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "kms:PutKeyPolicy",
      "kms:CreateAlias",
      "kms:DescribeKey"
    ]

    resources = [
      "arn:aws:kms:*:${var.aws_account_id}:alias/*",
      "arn:aws:kms:*:${var.aws_account_id}:key/*"
    ]
  }
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObjectAcl",
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.artifacts.arn}/*",
      "${aws_s3_bucket.artifacts_prd.arn}/*"
    ]
  }

  statement {
    effect    = "Allow"
    actions   = ["iam:PassRole"]
    resources = ["*"]
    condition {
      test = "StringEqualsIfExists"
      variable = "iam:PassedToService"
      values = [
          "cloudformation.amazonaws.com",
          "elasticbeanstalk.amazonaws.com",
          "ec2.amazonaws.com",
          "ecs-tasks.amazonaws.com"
      ]
    }
  }
  
  statement {
    effect    = "Allow"
    actions   = ["codecommit:*"]
    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild"
    ]

    resources = ["*"]
  }
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    resources = [
      aws_iam_role.cfn_lambda_deploy_role.arn,
      aws_iam_role.codepipeline_source_role.arn
    ]
  }
}


resource "aws_iam_role_policy" "codepipeline_policy" {
  name   = "codepipeline_policy"
  role   = aws_iam_role.codepipeline_role.id
  policy = data.aws_iam_policy_document.codepipeline_policy.json
}


### 4. Code Source IAM Role ###

resource "aws_iam_role" "codepipeline_source_role" {
  name               = var.codesource_iam_role
  assume_role_policy = data.aws_iam_policy_document.pipeline_source_assume_role.json
}

data "aws_iam_policy_document" "pipeline_source_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.aws_account_id}:root"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "codepipeline_source_policy" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObjectAcl",
      "s3:PutObject",
    ]

    resources = [
      aws_s3_bucket.artifacts.arn,
      "${aws_s3_bucket.artifacts.arn}/*",
      aws_s3_bucket.artifacts_prd.arn,
      "${aws_s3_bucket.artifacts_prd.arn}/*"      
    ]
  }

  statement {
    effect    = "Allow"
    actions   = ["codecommit:*"]
    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "codepipeline_source_policy" {
  name   = "codepipeline_policy"
  role   = aws_iam_role.codepipeline_source_role.id
  policy = data.aws_iam_policy_document.codepipeline_source_policy.json
}


### 5. Code Build IAM Role ###

resource "aws_iam_role" "codebuild" {
  name               = var.codebuild_iam_role
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role.json
}

data "aws_iam_policy_document" "codebuild_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "codebuild" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "ssm:GetParameter"
    ]

    resources = ["*"]
  }  

  statement {
    effect    = "Allow"
    actions   = ["ec2:CreateNetworkInterfacePermission"]
    resources = ["arn:aws:ec2:${var.region}:${data.aws_caller_identity.current.account_id}:network-interface/*"]


    condition {
      test     = "StringEquals"
      variable = "ec2:AuthorizedService"
      values   = ["codebuild.amazonaws.com"]
    }
  }

  statement {
    effect  = "Allow"
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.artifacts.arn,
      "${aws_s3_bucket.artifacts.arn}/*",
      aws_s3_bucket.artifacts_prd.arn,
      "${aws_s3_bucket.artifacts_prd.arn}/*",
    ]
  }
}

resource "aws_iam_role_policy" "codedeploy_permission" {
  role   = aws_iam_role.codebuild.name
  policy = data.aws_iam_policy_document.codebuild.json
}


### 6. AWSCloudFormationStackSetAdministrationRole
resource "aws_iam_role" "AWSCloudFormationStackSetAdministrationRole" {
  name   = "AWSCloudFormationStackSetAdministrationRole"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudformation.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}


// AWSLambdaS3ExecutionRole ----------
resource "aws_iam_policy" "AWSCloudFormationStackSetAdministrationRole_policy" {
  name   = "cloudformation-executionrole-policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "sts:AssumeRole"
            ],
            "Resource": [
                "arn:aws:iam::*:role/AWSCloudFormationStackSetExecutionRole"
            ],
            "Effect": "Allow"
        }
    ]
}
EOF
}

// ---------- Attach Custom IAM Policies ----------
resource "aws_iam_role_policy_attachment" "attach-AWSCloudFormationStackSetAdministrationRole-policy" {
  role       = aws_iam_role.AWSCloudFormationStackSetAdministrationRole.name
  policy_arn = aws_iam_policy.AWSCloudFormationStackSetAdministrationRole_policy.arn
}
