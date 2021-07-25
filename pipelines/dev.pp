{
  "appConfig": {},
  "keepWaitingPipelines": false,
  "limitConcurrent": true,
  "name": "dev",
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
        "publish_code": "true",
        "region": "us-east-1",
        "s3_key": "${parameters.deployment_package_s3_path}"
      },
      "refId": "1",
      "requisiteStageRefIds": [],
      "type": "updateAWSLambdaFunctionCode"
    },
    {
      "alias": "preconfiguredJob",
      "name": "Test invocation",
      "parameters": {
        "account": "ps2-nonprod",
        "function_name": "marinerexamples-demo-lambda-helloworld",
        "invocation_type": "RequestResponse",
        "log_type": "Tail",
        "payload": "\"hello world!\"",
        "qualifier": "$LATEST",
        "region": "us-east-1"
      },
      "refId": "2",
      "requisiteStageRefIds": [
        "1"
      ],
      "type": "invokeAWSLambdaFunction"
    }
  ],
  "triggers": [
    {
      "enabled": true,
      "payloadConstraints": {
        "branch": "develop",
        "git_repo": "Build/mariner-demo-lambda",
        "package_name": "sls-demo"
      },
      "runAsUser": "pipeline-trigger",
      "source": "artifact_published",
      "type": "webhook"
    }
  ]
}