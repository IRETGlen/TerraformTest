## AWS Code Pipeline Resource configuration ##

# -----------------------------------------------
# PIPELINE 1 - Staging
# -----------------------------------------------
resource "aws_codepipeline" "codepipeline" {
  name     = var.stg_pipeline_name
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.artifacts.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      role_arn         = "${aws_iam_role.codepipeline_source_role.arn}"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName       = var.commit_respository_name
        BranchName           = "stg"
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
    name = "CreatePullRequest"
    action {
      name            = "LambdaCreatePullRequest"
      category        = "Invoke"
      owner           = "AWS"
      provider        = "Lambda"
      version         = "1"

      configuration = {
        "FunctionName": var.lambda_name   
      }
    }
  }

}

## Deploy SNS Topics and subscriptions
resource "aws_sns_topic" "hyoka_cicd_sns" {
  name         = var.sns_topic_name
  display_name = var.sns_topic_name

  policy = <<EOF
{
  "Version": "2008-10-17",
  "Id": "__default_policy_ID",
  "Statement": [
    {
      "Sid": "__default_statement_ID",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "SNS:GetTopicAttributes",
        "SNS:SetTopicAttributes",
        "SNS:AddPermission",
        "SNS:RemovePermission",
        "SNS:DeleteTopic",
        "SNS:Subscribe",
        "SNS:ListSubscriptionsByTopic",
        "SNS:Publish"
      ],
      "Resource": "arn:aws:sns:ap-northeast-1:505982390831:hyoka-admin-cicd-sns-topic",
      "Condition": {
        "StringEquals": {
          "AWS:SourceOwner": "505982390831"
        }
      }
    },
    {
      "Sid": "CodeNotification_publish",
      "Effect": "Allow",
      "Principal": {
        "Service": "codestar-notifications.amazonaws.com"
      },
      "Action": "SNS:Publish",
      "Resource": "arn:aws:sns:ap-northeast-1:505982390831:hyoka-admin-cicd-sns-topic"
    }

  ]
}
EOF  
}

resource "aws_sns_topic_subscription" "development_admin" {
  topic_arn = aws_sns_topic.hyoka_cicd_sns.arn
  protocol  = "email"
  endpoint  = var.devadmin_email
}

## Deploy SSM Parameters for version approval/management

## _Create Parameters to prepare for deployment usage_

# resource "aws_ssm_parameter" "dev" {
#   name  = "/release-pipeline/stg_approval"
#   type  = "String"
#   value = "0"
# }

# resource "aws_ssm_parameter" "ver" {
#   name  = "/release-pipeline/version_approval"
#   type  = "String"
#   value = "0"
# }

## S3 Bucket configuration ##

resource "aws_s3_bucket" "artifacts" {
  bucket        = var.stg_artifact_bucket_name
  force_destroy = true
  tags          = local.tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "codepipeline_bucket_encryption" {
  bucket = aws_s3_bucket.artifacts.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "codepipeline_bucket_versioning" {
  bucket  = aws_s3_bucket.artifacts.id
  versioning_configuration {
    status = "Enabled"
  }
}

/*
resource "aws_s3_bucket_acl" "codepipeline_bucket_acl" {
  bucket = aws_s3_bucket.artifacts.id
  acl    = "private"
}
*/

## Cloudwatch Event Configuration ##

resource "aws_cloudwatch_event_rule" "commit" {
  name        = "capture-codecommit-merge-event"
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
      referenceName = ["stg"]
    }
  })
}

resource "aws_cloudwatch_event_target" "codepipeline" {
  rule      = aws_cloudwatch_event_rule.commit.name
  arn       = aws_codepipeline.codepipeline.arn
  role_arn = aws_iam_role.lambda_event_bus_Role.arn
}



# -----------------------------------------------
# PIPELINE 2 - Production
# -----------------------------------------------

## AWS Code Pipeline Resource configuration ##

resource "aws_codepipeline" "codepipeline_prd" {
  name     = var.prd_pipeline_name
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.artifacts_prd.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      role_arn         = "${aws_iam_role.codepipeline_source_role.arn}"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName       = var.commit_respository_name
        BranchName           = "main"
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
        ProjectName = aws_codebuild_project.lambda_codebuild_prd.id
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CloudFormationStackSet"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        StackSetName      = "hyoka-cross-account-stack-set"
        TemplatePath      = "build_output::outputTemplate.yaml"
        DeploymentTargets = "build_output::accounts.json"
        Regions           = "ap-northeast-1"
        Capabilities      = "CAPABILITY_IAM,CAPABILITY_AUTO_EXPAND"
      }

    }
  }  
  
  stage {
    name = "Verification"
    action {
      name            = "TechnicalApproval"
      category        = "Approval"
      owner           = "AWS"
      provider        = "Manual"
      version         = "1"
      run_order        = "1"

      configuration = {
        "CustomData": "顧客用アカウントへのLambda構築が完了しました。承認をお願いします。", # Comment data for SNS notification
        "NotificationArn": aws_sns_topic.hyoka_cicd_sns.arn
      }
    }
  }

}

## Deploy SSM Parameters for version approval/management

## _Create Parameters to prepare for deployment usage_

# resource "aws_ssm_parameter" "dev" {
#   name  = "/release-pipeline/stg_approval"
#   type  = "String"
#   value = "0"
# }

# resource "aws_ssm_parameter" "ver" {
#   name  = "/release-pipeline/version_approval"
#   type  = "String"
#   value = "0"
# }

## S3 Bucket configuration ##

resource "aws_s3_bucket" "artifacts_prd" {
  bucket        = var.prd_artifact_bucket_name
  force_destroy = true
  tags          = local.tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "codepipeline_bucket_encryption_prd" {
  bucket = aws_s3_bucket.artifacts_prd.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "codepipeline_bucket_versioning_prd" {
  bucket  = aws_s3_bucket.artifacts_prd.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.artifacts_prd.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    principals {
      type        = "AWS"
      identifiers = var.cross_account_ids
    }

    actions = [
      "s3:Get*",
      "s3:Put*",
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.artifacts_prd.arn,
      "${aws_s3_bucket.artifacts_prd.arn}/*",
    ]
  }
}


## Cloudwatch Event Configuration ##

resource "aws_cloudwatch_event_rule" "commit_main" {
  name        = "capture-codecommit-merge-event-main"
  description = "Capture event when a merge occurs on codecommit to main branch."

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

resource "aws_cloudwatch_event_target" "codepipeline_prd" {
  rule      = aws_cloudwatch_event_rule.commit_main.name
  arn       = aws_codepipeline.codepipeline_prd.arn
  role_arn  = aws_iam_role.lambda_event_bus_Role.arn
}
