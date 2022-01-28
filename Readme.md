# Simple Terraform AWS lambda, API GATEWAY

_tech_:
lambda, API Gateway, SG, VPC, CI/CD(workflow), Python

## Setup

This Repo has been tested automatically with GitHub workflow for deploying you need to install AWS CLI as well
as `access_key_id` and `access_key_secret` after creating a user with the right permissions and at least programmatic 
access to AWS along with initializing the AWS CLI, then you need the terraform cli,
also a workspace on terraform, (per sure you need an account) after that just go the target folder (e.g. cd terraform_simple_task):

## Tests in Workflow

- terraform format 
- terraform validation 
- terraform apply
- terraform destroy
- api endpoint tests

## Running

`terraform init`

`terraform apply --auto-approve`

then it returns the AWS_API_GATEWAY endpoint (named base_url) which you can send GET request to that ( {base_url}/hello) like :
`curl "$(terraform output -raw base_url)/hello"` then it returns a JSON response.

### NOTICE

> It's not safe to deploy, only for tests purposes.
