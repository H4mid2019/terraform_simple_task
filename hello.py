import json
import logging
import os
import boto3

logger = logging.getLogger()
logger.setLevel(logging.INFO)

LAMBDA_FUNCTION_NAME = os.getenv("CAT_LAMBDA")

client = boto3.client('lambda')

def lambda_handler(event, context):
    response = client.invoke(
        FunctionName = LAMBDA_FUNCTION_NAME,
        InvocationType = 'RequestResponse'
    )
    fact = json.load(response['Payload']).get("fact")
    logger.info(str(fact) + str(type(fact)))
    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps({
            "message ": "Traditional Hello world",
            "fact" : fact
        })
    }