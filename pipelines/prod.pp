{
  "appConfig": {},
  "keepWaitingPipelines": false,
  "limitConcurrent": true,
  "name": "prod",
  "parameterConfig": [
    {
      "default": "",
      "description": "",
      "hasOptions": false,
      "label": "Package S3 Path",
      "name": "deployment_package_s3_path",
      "options": [
        {
          "value": ""
        }
      ],
      "pinned": false,
      "required": true
    }
  ],
  "spelEvaluator": "v4",
  "stages": [
    {
      "alias": "preconfiguredJob",
      "name": "Update function code",
      "parameters": {
        "account": "ps2-nonprod",
        "function_name": "marinerexamples-demo-lambda-helloworld",
        "publish_code": "false",
        "region": "us-east-1",
        "s3_key": "${parameters.deployment_package_s3_path}"
      },
      "refId": "1",
      "requisiteStageRefIds": [],
      "type": "updateAWSLambdaFunctionCode"
    },
    {
      "alias": "preconfiguredJob",
      "name": "Invoke AWS lambda function",
      "parameters": {
        "account": "ps2-nonprod",
        "function_name": "marinerexamples-demo-lambda-helloworld",
        "invocation_type": "RequestResponse",
        "log_type": "Tail",
        "payload": "{\"message\": \"testevent\"}",
        "qualifier": "$LATEST",
        "region": "us-east-1"
      },
      "refId": "2",
      "requisiteStageRefIds": [
        "1"
      ],
      "type": "invokeAWSLambdaFunction"
    },
    {
      "failPipeline": true,
      "instructions": "Proceed?",
      "judgmentInputs": [],
      "name": "Manual Judgment",
      "notifications": [],
      "refId": "3",
      "requisiteStageRefIds": [
        "2"
      ],
      "type": "manualJudgment"
    },
    {
      "alias": "preconfiguredJob",
      "name": "Publish new version",
      "parameters": {
        "account": "ps2-nonprod",
        "function_name": "marinerexamples-demo-lambda-helloworld",
        "operation": "publish_version",
        "parameters": "",
        "region": "us-east-1"
      },
      "refId": "4",
      "requisiteStageRefIds": [
        "3"
      ],
      "type": "awsLambdaOperation"
    },
    {
      "alias": "preconfiguredJob",
      "name": "Update prod alias",
      "parameters": {
        "account": "ps2-nonprod",
        "function_name": "marinerexamples-demo-lambda-helloworld",
        "operation": "update_alias",
        "parameters": "{\"Name\": \"prod\", \"FunctionVersion\": \"${#stage('Publish new version')['context']['response']['Version']}\"}",
        "region": "us-east-1"
      },
      "refId": "5",
      "requisiteStageRefIds": [
        "4"
      ],
      "type": "awsLambdaOperation"
    }
  ],
  "triggers": [
    {
      "enabled": true,
      "payloadConstraints": {
        "branch": "master",
        "git_repo": "Build/mariner-demo-lambda",
        "package_name": "sls-demo"
      },
      "runAsUser": "pipeline-trigger",
      "source": "artifact_published",
      "type": "webhook"
    }
  ]
}