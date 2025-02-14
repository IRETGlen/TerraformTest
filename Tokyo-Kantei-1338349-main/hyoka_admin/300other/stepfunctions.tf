# -----------------------------------------------
# 1. ActionRenkeiKeyDeleteBuild
# Log level: OFF
# Include execution data: No
# -----------------------------------------------
resource "aws_sfn_state_machine" "sfn_ActionRenkeiKeyDeleteBuild" {
  name     = "ActionRenkeiKeyDeleteBuild"
  role_arn = data.terraform_remote_state.compute_layer.outputs.hyoka_shusys_step_lambda_role

  definition = <<EOF
{
  "Comment": "A description of my state machine",
  "StartAt": "Map",
  "States": {
    "Map": {
      "Type": "Map",
      "ItemProcessor": {
        "ProcessorConfig": {
          "Mode": "INLINE"
        },
        "StartAt": "read_inputCSV",
        "States": {
          "read_inputCSV": {
            "Type": "Task",
            "Resource": "arn:aws:states:::lambda:invoke",
            "OutputPath": "$.Payload",
            "Parameters": {
              "Payload.$": "$",
              "FunctionName": "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:pass-large-payload:$LATEST"
            },
            "Retry": [
              {
                "ErrorEquals": [
                  "Lambda.ServiceException",
                  "Lambda.AWSLambdaException",
                  "Lambda.SdkClientException",
                  "Lambda.TooManyRequestsException"
                ],
                "IntervalSeconds": 2,
                "MaxAttempts": 6,
                "BackoffRate": 2
              }
            ],
            "Next": "ActionRenkeiKeyDeleteBuild"
          },
          "ActionRenkeiKeyDeleteBuild": {
            "Type": "Task",
            "Resource": "arn:aws:states:::lambda:invoke",
            "OutputPath": "$.Payload",
            "Parameters": {
              "Payload.$": "$",
              "FunctionName": "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:ActionRenkeiKeyDeleteBuild:$LATEST"
            },
            "Retry": [
              {
                "ErrorEquals": [
                  "Lambda.ServiceException",
                  "Lambda.AWSLambdaException",
                  "Lambda.SdkClientException",
                  "Lambda.TooManyRequestsException"
                ],
                "IntervalSeconds": 2,
                "MaxAttempts": 6,
                "BackoffRate": 2
              }
            ],
            "End": true
          }
        }
      },
      "End": true,
      "ItemsPath": "$.input_file_list",
      "MaxConcurrency": 40
    }
  }
}
EOF
}

# -----------------------------------------------
# 2. CheckLoadRenkeiKey
# Log level: OFF
# Include execution data: No
# -----------------------------------------------
resource "aws_sfn_state_machine" "sfn_CheckLoadRenkeiKey" {
  name     = "CheckLoadRenkeiKey"
  role_arn = data.terraform_remote_state.compute_layer.outputs.hyoka_shusys_step_lambda_role

  definition = <<EOF
{
  "Comment": "A description of my state machine",
  "StartAt": "CheckLoadRenkeiKey",
  "States": {
    "CheckLoadRenkeiKey": {
      "Type": "Task",
      "Resource": "arn:aws:states:::lambda:invoke",
      "OutputPath": "$.Payload",
      "Parameters": {
        "Payload.$": "$",
        "FunctionName": "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:CheckLoadRenkeiKey:$LATEST"
      },
      "Retry": [
        {
          "ErrorEquals": [
            "Lambda.ServiceException",
            "Lambda.AWSLambdaException",
            "Lambda.SdkClientException",
            "Lambda.TooManyRequestsException"
          ],
          "IntervalSeconds": 2,
          "MaxAttempts": 6,
          "BackoffRate": 2
        }
      ],
      "End": true
    }
  }
}
EOF
}

# -----------------------------------------------
# 3. ActionRenkeiKeyEditFreeKey
# Log level: OFF
# Include execution data: No
# -----------------------------------------------
resource "aws_sfn_state_machine" "sfn_ActionRenkeiKeyEditFreeKey" {
  name     = "ActionRenkeiKeyEditFreeKey"
  role_arn = data.terraform_remote_state.compute_layer.outputs.hyoka_shusys_step_lambda_role

  definition = <<EOF
{
  "Comment": "A description of my state machine",
  "StartAt": "Map",
  "States": {
    "Map": {
      "Type": "Map",
      "ItemProcessor": {
        "ProcessorConfig": {
          "Mode": "INLINE"
        },
        "StartAt": "read_inputCSV",
        "States": {
          "read_inputCSV": {
            "Type": "Task",
            "Resource": "arn:aws:states:::lambda:invoke",
            "OutputPath": "$.Payload",
            "Parameters": {
              "Payload.$": "$",
              "FunctionName": "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:pass-large-payload:$LATEST"
            },
            "Retry": [
              {
                "ErrorEquals": [
                  "Lambda.ServiceException",
                  "Lambda.AWSLambdaException",
                  "Lambda.SdkClientException",
                  "Lambda.TooManyRequestsException"
                ],
                "IntervalSeconds": 2,
                "MaxAttempts": 6,
                "BackoffRate": 2
              }
            ],
            "Next": "ActionRenkeiKeyEditFreeKey"
          },
          "ActionRenkeiKeyEditFreeKey": {
            "Type": "Task",
            "Resource": "arn:aws:states:::lambda:invoke",
            "OutputPath": "$.Payload",
            "Parameters": {
              "Payload.$": "$",
              "FunctionName": "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:ActionRenkeiKeyEditFreeKey:$LATEST"
            },
            "Retry": [
              {
                "ErrorEquals": [
                  "Lambda.ServiceException",
                  "Lambda.AWSLambdaException",
                  "Lambda.SdkClientException",
                  "Lambda.TooManyRequestsException"
                ],
                "IntervalSeconds": 2,
                "MaxAttempts": 6,
                "BackoffRate": 2
              }
            ],
            "End": true
          }
        }
      },
      "End": true,
      "ItemsPath": "$.input_file_list",
      "MaxConcurrency": 40
    }
  }
}
EOF
}

# -----------------------------------------------
# 4. CreateCSV
# Log level: ERROR
# CloudWatch log group: /aws/vendedlogs/states/CreateCSV-Logs
# Include execution data: Yes
# -----------------------------------------------
resource "aws_cloudwatch_log_group" "create_csv_logs" {
  name              = "/aws/vendedlogs/states/CreateCSV-Logs"
  retention_in_days = 7
}

resource "aws_sfn_state_machine" "sfn_CreateCSV" {
  name     = "CreateCSV"
  role_arn = data.terraform_remote_state.compute_layer.outputs.hyoka_shusys_step_lambda_role
  
  logging_configuration {
    log_destination        = "${aws_cloudwatch_log_group.create_csv_logs.arn}:*"
    include_execution_data = true
    level                  = "ERROR"
  }

  definition = <<EOF
{
  "Comment": "A description of my state machine",
  "StartAt": "StartGetlistCSV",
  "States": {
    "StartGetlistCSV": {
      "Type": "Task",
      "Resource": "arn:aws:states:::lambda:invoke",
      "OutputPath": "$.Payload",
      "Parameters": {
        "Payload.$": "$",
        "FunctionName": "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:StartGetListCsv:$LATEST"
      },
      "Retry": [
        {
          "ErrorEquals": [
            "Lambda.ServiceException",
            "Lambda.AWSLambdaException",
            "Lambda.SdkClientException"
          ],
          "IntervalSeconds": 2,
          "MaxAttempts": 6,
          "BackoffRate": 2
        }
      ],
      "Next": "CreateCSV"
    },
    "CreateCSV": {
      "Type": "Map",
      "Iterator": {
        "StartAt": "read_inputCSV",
        "States": {
          "read_inputCSV": {
            "Type": "Task",
            "Resource": "arn:aws:states:::lambda:invoke",
            "OutputPath": "$.Payload",
            "Parameters": {
              "Payload.$": "$",
              "FunctionName": "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:pass-large-payload:$LATEST"
            },
            "Retry": [
              {
                "ErrorEquals": [
                  "Lambda.ServiceException",
                  "Lambda.AWSLambdaException",
                  "Lambda.SdkClientException"
                ],
                "IntervalSeconds": 2,
                "MaxAttempts": 6,
                "BackoffRate": 2
              }
            ],
            "Next": "CreateListCsv"
          },
          "CreateListCsv": {
            "Type": "Task",
            "Resource": "arn:aws:states:::lambda:invoke",
            "OutputPath": "$.Payload",
            "Parameters": {
              "FunctionName": "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:CreateListCsv",
              "Payload.$": "$"
            },
            "Retry": [
              {
                "ErrorEquals": [
                  "Lambda.ServiceException",
                  "Lambda.AWSLambdaException",
                  "Lambda.SdkClientException"
                ],
                "IntervalSeconds": 2,
                "MaxAttempts": 6,
                "BackoffRate": 2
              }
            ],
            "End": true
          }
        }
      },
      "Next": "CombineListCsv",
      "MaxConcurrency": 40,
      "ItemsPath": "$.input_file_list"
    },
    "CombineListCsv": {
      "Type": "Task",
      "Resource": "arn:aws:states:::lambda:invoke",
      "OutputPath": "$.Payload",
      "Parameters": {
        "Payload.$": "$",
        "FunctionName": "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:CombineListCsv:$LATEST"
      },
      "Retry": [
        {
          "ErrorEquals": [
            "Lambda.ServiceException",
            "Lambda.AWSLambdaException",
            "Lambda.SdkClientException"
          ],
          "IntervalSeconds": 2,
          "MaxAttempts": 6,
          "BackoffRate": 2
        }
      ],
      "End": true
    }
  }
}
EOF
}

# -----------------------------------------------
# 5. ActionRenkeiKeyEditRenkeiKey
# Log level: OFF
# Include execution data: No
# -----------------------------------------------
resource "aws_sfn_state_machine" "sfn_ActionRenkeiKeyEditRenkeiKey" {
  name     = "ActionRenkeiKeyEditRenkeiKey"
  role_arn = data.terraform_remote_state.compute_layer.outputs.hyoka_shusys_step_lambda_role

  definition = <<EOF
{
  "Comment": "A description of my state machine",
  "StartAt": "Map",
  "States": {
    "Map": {
      "Type": "Map",
      "ItemProcessor": {
        "ProcessorConfig": {
          "Mode": "INLINE"
        },
        "StartAt": "read_inputCSV",
        "States": {
          "read_inputCSV": {
            "Type": "Task",
            "Resource": "arn:aws:states:::lambda:invoke",
            "OutputPath": "$.Payload",
            "Parameters": {
              "Payload.$": "$",
              "FunctionName": "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:pass-large-payload:$LATEST"
            },
            "Retry": [
              {
                "ErrorEquals": [
                  "Lambda.ServiceException",
                  "Lambda.AWSLambdaException",
                  "Lambda.SdkClientException",
                  "Lambda.TooManyRequestsException"
                ],
                "IntervalSeconds": 2,
                "MaxAttempts": 6,
                "BackoffRate": 2
              }
            ],
            "Next": "ActionRenkeiKeyEditRenkeiKey"
          },
          "ActionRenkeiKeyEditRenkeiKey": {
            "Type": "Task",
            "Resource": "arn:aws:states:::lambda:invoke",
            "OutputPath": "$.Payload",
            "Parameters": {
              "Payload.$": "$",
              "FunctionName": "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:ActionRenkeiKeyEditRenkeiKey:$LATEST"
            },
            "Retry": [
              {
                "ErrorEquals": [
                  "Lambda.ServiceException",
                  "Lambda.AWSLambdaException",
                  "Lambda.SdkClientException",
                  "Lambda.TooManyRequestsException"
                ],
                "IntervalSeconds": 2,
                "MaxAttempts": 6,
                "BackoffRate": 2
              }
            ],
            "End": true
          }
        }
      },
      "End": true,
      "ItemsPath": "$.input_file_list",
      "MaxConcurrency": 40
    }
  }
}
EOF
}

# -----------------------------------------------
# 6. ActionRenkeiKeyEditOptionalItem
# Log level: OFF
# Include execution data: No
# -----------------------------------------------
resource "aws_sfn_state_machine" "sfn_ActionRenkeiKeyEditOptionalItem" {
  name     = "ActionRenkeiKeyEditOptionalItem"
  role_arn = data.terraform_remote_state.compute_layer.outputs.hyoka_shusys_step_lambda_role

  definition = <<EOF
{
  "Comment": "A description of my state machine",
  "StartAt": "Map",
  "States": {
    "Map": {
      "Type": "Map",
      "ItemProcessor": {
        "ProcessorConfig": {
          "Mode": "INLINE"
        },
        "StartAt": "read_inputCSV",
        "States": {
          "read_inputCSV": {
            "Type": "Task",
            "Resource": "arn:aws:states:::lambda:invoke",
            "OutputPath": "$.Payload",
            "Parameters": {
              "Payload.$": "$",
              "FunctionName": "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:pass-large-payload:$LATEST"
            },
            "Retry": [
              {
                "ErrorEquals": [
                  "Lambda.ServiceException",
                  "Lambda.AWSLambdaException",
                  "Lambda.SdkClientException",
                  "Lambda.TooManyRequestsException"
                ],
                "IntervalSeconds": 2,
                "MaxAttempts": 6,
                "BackoffRate": 2
              }
            ],
            "Next": "ActionRenkeiKeyEditOptionalItem"
          },
          "ActionRenkeiKeyEditOptionalItem": {
            "Type": "Task",
            "Resource": "arn:aws:states:::lambda:invoke",
            "OutputPath": "$.Payload",
            "Parameters": {
              "Payload.$": "$",
              "FunctionName": "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:ActionRenkeiKeyEditOptionalItem:$LATEST"
            },
            "Retry": [
              {
                "ErrorEquals": [
                  "Lambda.ServiceException",
                  "Lambda.AWSLambdaException",
                  "Lambda.SdkClientException",
                  "Lambda.TooManyRequestsException"
                ],
                "IntervalSeconds": 2,
                "MaxAttempts": 6,
                "BackoffRate": 2
              }
            ],
            "End": true
          }
        }
      },
      "End": true,
      "ItemsPath": "$.input_file_list",
      "MaxConcurrency": 40
    }
  }
}
EOF
}

# -----------------------------------------------
# 7. CreateCSVProspect
# Log level: OFF
# Include execution data: No
# -----------------------------------------------
resource "aws_sfn_state_machine" "sfn_CreateCSVProspect" {
  name     = "CreateCSVProspect"
  role_arn = data.terraform_remote_state.compute_layer.outputs.hyoka_shusys_step_lambda_role

  definition = <<EOF
{
  "Comment": "A description of my state machine",
  "StartAt": "StartGetlistCSV",
  "States": {
    "StartGetlistCSV": {
      "Type": "Task",
      "Resource": "arn:aws:states:::lambda:invoke",
      "OutputPath": "$.Payload",
      "Parameters": {
        "Payload.$": "$",
        "FunctionName": "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:StartGetListCsvProspect:$LATEST"
      },
      "Retry": [
        {
          "ErrorEquals": [
            "Lambda.ServiceException",
            "Lambda.AWSLambdaException",
            "Lambda.SdkClientException"
          ],
          "IntervalSeconds": 2,
          "MaxAttempts": 6,
          "BackoffRate": 2
        }
      ],
      "Next": "CreateCSV"
    },
    "CreateCSV": {
      "Type": "Map",
      "Iterator": {
        "StartAt": "read_inputCSV",
        "States": {
          "read_inputCSV": {
            "Type": "Task",
            "Resource": "arn:aws:states:::lambda:invoke",
            "OutputPath": "$.Payload",
            "Parameters": {
              "Payload.$": "$",
              "FunctionName": "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:pass-large-payload:$LATEST"
            },
            "Retry": [
              {
                "ErrorEquals": [
                  "Lambda.ServiceException",
                  "Lambda.AWSLambdaException",
                  "Lambda.SdkClientException"
                ],
                "IntervalSeconds": 2,
                "MaxAttempts": 6,
                "BackoffRate": 2
              }
            ],
            "Next": "CreateListCsv"
          },
          "CreateListCsv": {
            "Type": "Task",
            "Resource": "arn:aws:states:::lambda:invoke",
            "OutputPath": "$.Payload",
            "Parameters": {
              "FunctionName": "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:CreateListCsvProspect",
              "Payload.$": "$"
            },
            "Retry": [
              {
                "ErrorEquals": [
                  "Lambda.ServiceException",
                  "Lambda.AWSLambdaException",
                  "Lambda.SdkClientException"
                ],
                "IntervalSeconds": 2,
                "MaxAttempts": 6,
                "BackoffRate": 2
              }
            ],
            "End": true
          }
        }
      },
      "Next": "CombineListCsv",
      "MaxConcurrency": 40,
      "ItemsPath": "$.input_file_list"
    },
    "CombineListCsv": {
      "Type": "Task",
      "Resource": "arn:aws:states:::lambda:invoke",
      "OutputPath": "$.Payload",
      "Parameters": {
        "Payload.$": "$",
        "FunctionName": "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:CombineListCsv:$LATEST"
      },
      "Retry": [
        {
          "ErrorEquals": [
            "Lambda.ServiceException",
            "Lambda.AWSLambdaException",
            "Lambda.SdkClientException"
          ],
          "IntervalSeconds": 2,
          "MaxAttempts": 6,
          "BackoffRate": 2
        }
      ],
      "End": true
    }
  }
}
EOF
}