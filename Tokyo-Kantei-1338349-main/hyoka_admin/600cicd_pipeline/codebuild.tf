## Code Build Project configuration ##

# ------------- PIPELINE 1 ----------------------------
resource "aws_codebuild_project" "lambda_codebuild" {
  name          = var.stg_codebuild_project_name
  description   = "hyoka codebuild project for stg pipeline"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild.arn

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    environment_variable {
      name = "ARTIFACT_BUCKET"
      value = var.stg_artifact_bucket_name
    }
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "lambda-codebuild-operationlog"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.artifacts.id}/build-log"
    }
  }

  source {
    type            = "CODEPIPELINE"
    buildspec       = "buildspec.yml"
  }

  tags = {
    Environment = var.environment
  }
}

# ------------- PIPELINE 2 ----------------------------
resource "aws_codebuild_project" "lambda_codebuild_prd" {
  name          = var.prd_codebuild_project_name
  description   = "hyoka codebuild project for prd pipeline"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild.arn

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    environment_variable {
      name = "ARTIFACT_BUCKET"
      value = var.prd_artifact_bucket_name
    }
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "lambda-codebuild-operationlog"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.artifacts.id}/build-log"
    }
  }

  source {
    type            = "CODEPIPELINE"
    buildspec       = "buildspec.yml"
  }

  tags = {
    Environment = var.environment
  }
}