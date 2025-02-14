resource "aws_codecommit_repository" "lambda_repo" {
  repository_name = var.commit_respository_name
  description     = "Code Commit Repo for Hyoka Lambda Functions"
  default_branch  = "main"
}

resource "aws_codecommit_approval_rule_template" "lambda_approval" {
  name        = "HyokaAdmin_Lambda_Approval_1"
  description = "This is an example approval rule template"

  content = jsonencode({
    Version               = "2018-11-08"
    DestinationReferences = ["refs/heads/main"] # reference the 'main' head for pull requests.
    Statements = [{
      Type                    = "Approvers"
      NumberOfApprovalsNeeded = 1
    }]
  })
}

resource "aws_codecommit_approval_rule_template_association" "approval_association" {
  approval_rule_template_name = aws_codecommit_approval_rule_template.lambda_approval.name
  repository_name             = aws_codecommit_repository.lambda_repo.repository_name
}

resource "aws_kms_key" "codegurukey" {}

resource "aws_codegurureviewer_repository_association" "lambda_review" {
  repository {
    codecommit {
      name = aws_codecommit_repository.lambda_repo.repository_name
    }
  }
  kms_key_details {
    encryption_option = "CUSTOMER_MANAGED_CMK"
    kms_key_id        = aws_kms_key.codegurukey.key_id
  }
}

## Trigger Pipeline 2
resource "aws_codestarnotifications_notification_rule" "pullrequest_notification" {
  detail_type    = "BASIC"
  event_type_ids = ["codecommit-repository-pull-request-created"]
  name           = "pullrequest-created-notification"
  resource       = aws_codecommit_repository.lambda_repo.arn

  target {
    address = aws_sns_topic.hyoka_cicd_sns.arn
  }
}
