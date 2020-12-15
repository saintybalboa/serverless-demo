# Serverless demo

Defines an AWS infrastructure for the following services:
- UI: Lambda@Edge & Cloudfront
- API: Amazon API Gateway
- Database: AWS RDS Posgres **(TBC)**
- Background jobs: Lambda, SQS & SNS **(TBC)**

## Instructions

Create a public hosted zone in AWS Route 53 to route traffic for a your custom domain.

## Local setup

Set the access token for authenticating against the Github package registry.
```bash
export NPM_AUTH_TOKEN=XXXX
```

Install dependencies:
```bash
npm i -g serverless
npm i
```

## Deployments

Github workflows are used for the deployment of services within the Serverless Demo infrastructure. A Github personal access token has been setup to provide Serverless Demo Infrastructure builds access to the other repositories. AWS environment variables `AWS_ACCESS_KEY_ID` & `AWS_SECRET_ACCESS_KEY` are set from the values stored in secrets to allow Serverless to deploy the infrastructure to AWS from Github.

### UI

Deploys the [NextJS Demo](https://github.com/saintybalboa/nextjs-demo) web app to a custom domain in AWS. This is done using the [Serverless Next.js Component](https://www.serverless.com/blog/serverless-nextjs) which utilises the Serverless Framework to deploy Next.js apps to AWS Lambda@Edge functions in every AWS CloudFront edge locations.

#### Automated deployments

A [Github Action](./.github/workflows/ui-deploy.yml) has been setup to deploy the NextJS Demo application stack to the development domain in AWS. This action uses the `repository_dispatch` event to allow the job to be triggered via the Github API. The [nextjs-demo](https://github.com/saintybalboa/nextjs-demo) repo has a Github Action setup to trigger the event when changes are merged into it's `main` branch. As a result we get automated deployments to the development environment.

#### Manual deployments

A [Github Action](./.github/workflows/ui-manual-deploy.yml) has been setup to allow deployments to the production domain in AWS to be triggered manually via the Github interface.

Manual deployments can also be carried out on your local machine. Ensure [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-mac.html) is installed on your local machine and that the `AWS_ACCESS_KEY_ID` & `AWS_SECRET_ACCESS_KEY` environment variables are set. This is required to allow Serverless to deploy the infrastructure to AWS from your local machine.

Checkout the UI repository:
```bash
REPO=saintybalboa/nextjs-demo COMMIT_HASH=main SERVICE=ui make checkout-repo
```

Deploy stack to AWS:
```bash
cd ./ui &&
BUCKET=serverless-demo-ui-bucket-dev DOMAIN_PREFIX=dev DOMAIN=msswebdevelopment.com API_BASE_URL=https://api-dev.msswebdevelopment.com REPO=saintybalboa/nextjs-demo make deploy
```

> **Please note:** It can take a few hours for the DNS changes of newly created domains to be updated across the Internet.

#### Removing

The UI infrastructure stack can also be be removed from a specific domain in AWS.

Remove stack from AWS:
```bash
cd ./ui &&
BUCKET=serverless-demo-ui-bucket-dev make remove
```

> **Important:** This will only remove the domain names and disable the CloudFront distribution. The CloudFront distribution will need to be deleted via the AWS console.

### API

Deploy the [AWS API Gateway Demo](https://github.com/saintybalboa/aws-api-gateway-demo) to a custom domain in AWS.

> **Important:** Certificates for an AWS API Gateway must be created in the us-east region in order to be applied to a CloudFront distribution.

Create certificate:
```bash
DOMAIN=api-dev.msswebdevelopment.com HOSTED_ZONE_ID=XXXX CERT_REGION=us-east-1 make create-cert
```

Checkout the API repository:
```bash
REPO=saintybalboa/aws-api-gateway-demo COMMIT_HASH=main SERVICE=api make checkout-repo
```

Deploy stack to AWS:
```bash
cd ./api &&
DOMAIN=api-dev.msswebdevelopment.com REPO=saintybalboa/aws-api-gateway-demo make deploy
```

#### Removing

Remove stack from AWS:
```bash
cd ./api &&
DOMAIN=api-dev.msswebdevelopment.com REPO=saintybalboa/aws-api-gateway-demo make remove
```

> **Please note:** It can take up to 40 minutes to delete the stack in AWS and remove the domain. The certificate cannot be removed until this process is complete.

Remove certificate:
```bash
DOMAIN=api-dev.msswebdevelopment.com HOSTED_ZONE_ID=XXXX CERT_REGION=us-east-1 make remove-cert
```
