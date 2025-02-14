## AWS Code Pipeline Resource configuration ##

resource "aws_codepipeline" "codepipeline" {
  name     = var.pipeline_name
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = data.aws_s3_bucket.artifacts.bucket
    type     = "S3"

  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      role_arn       = "${aws_iam_role.codepipeline_source_role.arn}"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName    = var.commit_respository_name
        BranchName       = "main"
        PollForSourceChanges = "false"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.lambda_codebuild.id
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CloudFormation"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        ActionMode     = "REPLACE_ON_FAILURE"
        Capabilities   = "CAPABILITY_AUTO_EXPAND,CAPABILITY_IAM"
        OutputFileName = "CreateStackOutput.json"
        RoleArn        = "${aws_iam_role.cfn_lambda_deploy_role.arn}"
        StackName      = var.cloudformation_stack_name
        TemplatePath   = "build_output::outputTemplate.yaml"
      }
    }
  }
  

  stage {
    name = "Testing-Verify"
    action {
      name            = "TechnicalApproval"
      category        = "Approval"
      owner           = "AWS"
      provider        = "Manual"
      version         = "1"
      run_order        = "1"

      configuration = {
        "CustomData": "新しい展開のテストが完了したため、レビューが必要です。\\n展開を確認し、次の段階に向けて承認してください。", # Comment data for SNS notification
        "ExternalEntityLink": "https://${var.apigateway_execution_url}/test/mansion-predict",
        "NotificationArn": data.aws_sns_topic.development_admin.arn
      }
    }
  }
  

  stage {
    name = "DEV-Verify"
    action {
      name            = "TechnicalApproval"
      category        = "Approval"
      owner           = "AWS"
      provider        = "Manual"
      version         = "1"
      run_order        = "1"

      configuration = {
        "CustomData": "「開発へのリリース」ステージが発生したため、レビューが必要です。\\n デプロイメントを確認し、次のステージに向けて承認してください。", # Comment data for SNS notification
        "ExternalEntityLink": "https://${var.apigateway_execution_url}/dev/mansion-predict",
        "NotificationArn": data.aws_sns_topic.development_admin.arn
      }
    }
    action {
      name            = "ApplicationApproval"
      category        = "Approval"
      owner           = "AWS"
      provider        = "Manual"
      version         = "1"
      run_order        = "2"

      configuration = {
        "CustomData": "「開発へのリリース」ステージが発生したため、レビューが必要です。\\n デプロイメントを確認し、次のステージに向けて承認してください。", # Comment data for SNS notification
        "ExternalEntityLink": "https://${var.apigateway_execution_url}/dev/mansion-predict",
        "NotificationArn": data.aws_sns_topic.application_admin.arn
      }
    }
  }
  

  stage {
    name = "VER-Verify"
    action {
      name            = "TechnicalApproval"
      category        = "Approval"
      owner           = "AWS"
      provider        = "Manual"
      version         = "1"
      run_order        = "1"

      configuration = {
        "CustomData": "「Ver へのリリース」ステージが発生したため、レビューが必要です。\\n デプロイメントを確認し、次のステージに向けて承認してください。", # Comment data for SNS notification
        "ExternalEntityLink": "https://${var.apigateway_execution_url}/ver/mansion-predict",
        "NotificationArn": data.aws_sns_topic.development_admin.arn
      }
    }
    action {
      name            = "ApplicationApproval"
      category        = "Approval"
      owner           = "AWS"
      provider        = "Manual"
      version         = "1"
      run_order        = "2"

      configuration = {
        "CustomData": "「Ver へのリリース」ステージが発生したため、レビューが必要です。\\n デプロイメントを確認し、次のステージに向けて承認してください。", # Comment data for SNS notification
        "ExternalEntityLink": "https://${var.apigateway_execution_url}/ver/mansion-predict",
        "NotificationArn": data.aws_sns_topic.application_admin.arn
      }
    }
  }
}

## S3 Bucket configuration ##

data "aws_s3_bucket" "artifacts" {
  bucket        = "${data.aws_caller_identity.current.account_id}-lambdaartifacts-${var.region}"
}


## SNS Topic Retrieval ##

variable "development_admin" {
  default = {
    name          = "aisatei-developer"
    display_name  = "aisatei-developer"
    email_address = "css.suzuki@kantei.co.jp"
  }
}

variable "application_admin" {
  default = {
    name          = "aisatei-staff"
    display_name  = "aisatei-staff"
    email_address = "yasunori.inoue@kantei.co.jp"
  }
}

data "aws_sns_topic" "development_admin" {
  name         = var.development_admin["name"]
}

data "aws_sns_topic" "application_admin" {
  name         = var.application_admin["name"]
}

/* 
resource "aws_s3_bucket" "artifacts" {
  bucket        = "${data.aws_caller_identity.current.account_id}-lambdaartifacts-${var.region}"
  force_destroy = true
  tags = local.tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "codepipeline_bucket_encryption" {
  bucket = data.aws_s3_bucket.artifacts.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "codepipeline_bucket_versioning" {
  bucket  = data.aws_s3_bucket.artifacts.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_acl" "codepipeline_bucket_acl" {
  bucket = data.aws_s3_bucket.artifacts.id
  acl    = "private"
}
 */

## Cloudwatch Event Configuration ##

resource "aws_cloudwatch_event_rule" "commit" {
  name        = "capture-codecommit-merge-event-2"
  description = "Capture event when a merge occurs on codecommit for repo."

  event_pattern = jsonencode({
    source = ["aws.codecommit"]
    detail-type = [
      "CodeCommit Repository State Change"
    ]
    resources = [
      "${aws_codecommit_repository.lambda_repo.arn}"
    ]
    detail = {
      event = [
        "referenceCreated",
        "referenceUpdated"
      ]
      referenceType = ["branch"]
      referenceName = ["main"]
    }
  })
}

resource "aws_cloudwatch_event_target" "codepipeline" {
  rule      = aws_cloudwatch_event_rule.commit.name
  arn       = aws_codepipeline.codepipeline.arn
  role_arn = aws_iam_role.lambda_event_bus_Role.arn
}

### Event Bridge IAM Role ##

resource "aws_iam_role" "lambda_event_bus_Role" {
  name               = "event-bus-invoke-remote-event-bus-2"
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
    resources = ["${aws_codepipeline.codepipeline.arn}"]
  }
}

resource "aws_iam_policy" "event_bus_invoke_remote_event_bus" {
  name   = "event_bus_invoke_remote_event_bus_2"
  policy = data.aws_iam_policy_document.event_bus_invoke_remote_event_bus.json
}

resource "aws_iam_role_policy_attachment" "event_bus_invoke_remote_event_bus" {
  role       = aws_iam_role.lambda_event_bus_Role.name
  policy_arn = aws_iam_policy.event_bus_invoke_remote_event_bus.arn
}


## IAM Role Definitions ##


### Cloudformation IAM Role ##

resource "aws_iam_role" "cfn_lambda_deploy_role" {
  name               = "cfn_lambda_deploy_role_2"
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
      "iam:ListRoleTags",
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
      "events:UntagResource"
    ]
    resources = ["*"]
  }
  statement {
    effect    = "Allow"
    actions   = [
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeVpcs"
    ]
    resources = [
        "*"
    ]
  }
  statement {
    effect    = "Allow"
    actions   = [
                "ssm:GetParameter*",
                "kms:*"
    ]
    resources = [
        "arn:aws:kms:*:${data.aws_caller_identity.current.account_id}:alias/*",
        "arn:aws:kms:*:${data.aws_caller_identity.current.account_id}:key/*",
        "arn:aws:ssm:*:${data.aws_caller_identity.current.account_id}:parameter/*"
    ]
  }
}

resource "aws_iam_policy" "cfn_deploy_role_policy" {
  name   = "cfn_deploy_role_policy_2"
  policy = data.aws_iam_policy_document.cfn_role_policy.json
}

resource "aws_iam_role_policy_attachment" "cfn_deploy_role_policy" {
  role       = aws_iam_role.cfn_lambda_deploy_role.name
  policy_arn = aws_iam_policy.cfn_deploy_role_policy.arn
}

data "aws_iam_policy" "aws_efsaccess_policy" {
  name = "AmazonElasticFileSystemClientReadWriteAccess"
}

resource "aws_iam_role_policy_attachment" "cfn_efsaccess_policy" {
  role       = aws_iam_role.cfn_lambda_deploy_role.name
  policy_arn = data.aws_iam_policy.aws_efsaccess_policy.arn
}


### Code Pipeline IAM Role ##

resource "aws_iam_role" "codepipeline_role" {
  name               = "codebuild-${var.pipeline_name}-pipeline-role-2"
  assume_role_policy = data.aws_iam_policy_document.pipeline_assume_role.json
}

data "aws_iam_policy_document" "pipeline_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
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
      "arn:aws:kms:*:${data.aws_caller_identity.current.account_id}:alias/*",
      "arn:aws:kms:*:${data.aws_caller_identity.current.account_id}:key/*"
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
      data.aws_s3_bucket.artifacts.arn,
      "${data.aws_s3_bucket.artifacts.arn}/*"
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


### Code Source IAM Role ##

resource "aws_iam_role" "codepipeline_source_role" {
  name               = "codebuild-${var.pipeline_name}-source-role-2"
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
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
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
      data.aws_s3_bucket.artifacts.arn,
      "${data.aws_s3_bucket.artifacts.arn}/*"
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
  name   = "codepipeline_policy_2"
  role   = aws_iam_role.codepipeline_source_role.id
  policy = data.aws_iam_policy_document.codepipeline_source_policy.json
}
