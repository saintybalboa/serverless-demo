# API

Deploy the [AWS ](https://github.com/saintybalboa/aws-api-gateway-demo) to AWS API Gateway under a custom domain in AWS.

## How it works

1. SSL certificate: Using the [Serverless Certificate Creator](https://github.com/schwamster/serverless-certificate-creator) plugin an SSL certificate is created specifically for the domain serving the API.

2. API: Uses the Serverless framework to deploy the api to Lambda functions served by API Gateway.

3. Domain: Using the [Serverless Domain Manager](https://github.com/amplify-education/serverless-domain-manager) plugin to assign a custom domain to Cloudfront which sits infront of the API Gateway.

Using the [Serverless Certificate Creator](https://github.com/schwamster/serverless-certificate-creator) plugin an SSL certificate is created specifically for the domain serving the API.

## Automated deployments

A [Github Action](./.github/workflows/api-deploy.yml) has been setup to deploy the AWS API Gateway Demo stack to the development domain in AWS. This action uses the `repository_dispatch` event to allow the job to be triggered via the Github API. The [markitool-api](https://github.com/saintybalboa/aws-api-gateway-demo) repo has a Github Action setup to trigger the event when changes are merged into it's `main` branch. As a result we get automated deployments to the development environment.

## Manual deployments

A [Github Action](./.github/workflows/api-manual-deploy.yml) has been setup to allow deployments to the production domain in AWS to be triggered manually via the Github interface

> **Important:** Certificates for an AWS API Gateway must be created in the us-east region in order to be applied to a CloudFront distribution.

Create certificate:
```bash
ENV=dev DOMAIN=api.dev.example.com HOSTED_ZONE_ID=XXXX make create-cert
```

Checkout the API repository:
```bash
REPO=saintybalboa/aws-api-gateway-demo COMMIT_HASH=main SERVICE=api make checkout-repo
```

Deploy stack to AWS:
```bash
cd ./api &&
ENV=dev DOMAIN=api.dev.example.com REPO=saintybalboa/aws-api-gateway-demo make deploy
```

## Removing

Remove stack from AWS:
```bash
cd ./api &&
ENV=dev DOMAIN=api.dev.example.com REPO=saintybalboa/aws-api-gateway-demo make remove
```

> **Please note:** It can take up to 40 minutes to delete the stack in AWS and remove the domain. The certificate cannot be removed until this process is complete.

Remove certificate:
```bash
ENV=dev DOMAIN=api.dev.example.com HOSTED_ZONE_ID=XXXX make remove-cert
```
