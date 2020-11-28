# Serverless demo

Defines and deploys the following infrastructure using the Serverless framework:
- Web: Lambda@Edge & Cloudfront
- API: Amazon API Gateway **(TBC)**
- Database: AWS RDS Posgres **(TBC)**
- Background jobs: Lambda, SQS & SNS **(TBC)**

## Initial setup

The initial setup creates an S3 bucket to store artifacts required by services in the Serverless Demo infrastructure. It also creates a dedicated bucket for serverless deployments. This is a one time setup only, for each environment (ie dev, test, prod) in AWS.

Install dependencies:
```bash
npm i
npm i -g serverless
```

Setup Serverless in AWS:
```bash
ENV=dev make setup
```

## Deployments

Github workflows are used for the deployment of services within the Serverless Demo infrastructure. A Github personal access token has been setup to provide Serverless Demo Infrastructure builds access to the other repositories. `AWS_ACCESS_KEY_ID` & `AWS_SECRET_ACCESS_KEY` environment variables are set from the values stored in secrets to allow Serverless to deploy the infrastructure to AWS from Github.

### NextJS Demo

Deployments are done using the [Serverless Next.js Component](https://www.serverless.com/blog/serverless-nextjs) which utilises the Serverless Framework to deploy Next.js apps to AWS Lambda@Edge functions in every AWS CloudFront edge locations.

#### Automated deployments

A [Github Action](./.github/workflows/ui-deploy.yml) has been setup to deploy the NextJS Demo application stack to the development domain in AWS. This action uses the `repository_dispatch` event to allow the job to be triggered via the Github API. The [nextjs-demo](https://github.com/saintybalboa/nextjs-demo) repo has a Github Action setup to trigger the event when changes are merged into it's `main` branch. As a result we get automated deployments to the development environment.

#### Manual deployments

A [Github Action](./.github/workflows/ui-manual-deploy.yml) has been setup to allow deployments to the production domain in AWS to be triggered manually via the Github interface.

Manual deployments can also be carried out on your local machine. Ensure [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-mac.html) is installed on your local machine and that the `AWS_ACCESS_KEY_ID` & `AWS_SECRET_ACCESS_KEY` environment variables are set. This is required to allow Serverless to deploy the infrastructure to AWS from your local machine.

From the `ui` directory run:
```bash
DOMAIN_PREFIX=dev API_BASE_URL=api-dev.msswebdevelopment.com COMMIT_HASH=main make deploy
```

#### Removing

The NextJS Demo application stack can also be be removed from a specific domain in AWS.
From the `ui` directory run:
```bash
cd ui
DOMAIN_PREFIX=dev make remove
```

**Important:** This will remove the domain names and disable the CloudFront distribution but it will not delete it. The CloudFront distribution will need to be delete via the AWS console.
