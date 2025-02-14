import boto3
from botocore.exceptions import ClientError

def lambda_handler(event, context):
           
    codecommit   = boto3.client('codecommit')
    codepipeline = boto3.client('codepipeline')
    
    cicd_repo_name = "hyoka-admin-cicd-codecommit-repo"

    # Create Pull Request
    pullrequest_response = codecommit.create_pull_request(
        title='lambda-pullrequest-from-lambda',
        description='Pull Request triggered by Lambda',
        targets=[
            {
                'repositoryName': cicd_repo_name,
                'sourceReference': 'stg',
                'destinationReference': 'main'
            },
        ],
    )

    codepipeline_response = codepipeline.put_job_success_result(
        jobId=event['CodePipeline.job']['id']
    )
    return codepipeline_response