# Simple Terraform AWS lambda, API GATEWAY

_tech_:
lambda, API Gateway, SG, VPC, CI/CD(workflow), Python, DynamoDB, ElastiCache(Redis)
This Repo has been tested automatically with GitHub workflow.


## What it's doing?

It demonstrates the connection between two lambda, lambda to API Gateway, lambda to DynamoDB, Lambda to redis,
Lambda to VPC and Internet.

The main lambda gets a cat fact from another lambda by every endpoint call. The other one also retrieves data
from DynamoDB or ElasticCache (randomly) that it got all data from an external API endpoint.

## Prerequisites

- Ubuntu (preferably a linux base machine)
- AWS access_key_id
- AWS access_key_secret
- AWS CLI
- Terraform Workspace
- Terraform Token
- Terraform CLI

## Setup

For deploying you need to install AWS CLI as well as `access_key_id` and `access_key_secret` after creating a user
with the correct permissions and at least programmatic access to AWS along with initializing the AWS CLI, then
you need terraform cli,also, a workspace on terraform (and the token), (per sure you need an account) after that
go to the target folder (e.g., cd terraform_simple_task):

## Tests in Workflow

- terraform format
- terraform validation
- terraform apply
- API endpoint tests
- terraform destroy

## Running

`terraform init`

`terraform apply --auto-approve`

then it returns the AWS_API_GATEWAY endpoint (named base_url) which you can send GET request to that like :
`curl "$(terraform output -raw base_url)"` then it returns a JSON response.

### NOTICE

> It's not safe to deploy, only for test purposes.


