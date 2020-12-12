# Serverless demo

Defines and deploys the following infrastructure using the Serverless framework:
- UI: Lambda@Edge & Cloudfront
- API: Amazon API Gateway **(TBC)**
- Database: AWS RDS Posgres **(TBC)**
- Background jobs: Lambda, SQS & SNS **(TBC)**

## Initial setup

Create host zone in Route 53 and poi custom domain creates an S3 bucket to store artifacts required by services in the Serverless Demo infrastructure. It also creates a dedicated bucket for serverless deployments. This is a one time setup only, for each environment (ie dev, test, prod) in AWS.

Install dependencies:
```bash
npm i -g serverless
npm i
```

## Deployments

Github workflows are used for the deployment of services within the Serverless Demo infrastructure. A Github personal access token has been setup to provide Serverless Demo Infrastructure builds access to the other repositories. `AWS_ACCESS_KEY_ID` & `AWS_SECRET_ACCESS_KEY` environment variables are set from the values stored in secrets to allow Serverless to deploy the infrastructure to AWS from Github.

### UI

Deploys the [NextJS Demo](https://github.com/saintybalboa/nextjs-demo) web app to a custom domain in AWS. This is done using the [Serverless Next.js Component](https://www.serverless.com/blog/serverless-nextjs) which utilises the Serverless Framework to deploy Next.js apps to AWS Lambda@Edge functions in every AWS CloudFront edge locations.

#### Automated deployments

A [Github Action](./.github/workflows/ui-deploy.yml) has been setup to deploy the NextJS Demo application stack to the development domain in AWS. This action uses the `repository_dispatch` event to allow the job to be triggered via the Github API. The [nextjs-demo](https://github.com/saintybalboa/nextjs-demo) repo has a Github Action setup to trigger the event when changes are merged into it's `main` branch. As a result we get automated deployments to the development environment.

#### Manual deployments

A [Github Action](./.github/workflows/ui-manual-deploy.yml) has been setup to allow deployments to the production domain in AWS to be triggered manually via the Github interface.

Manual deployments can also be carried out on your local machine. Ensure [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-mac.html) is installed on your local machine and that the `AWS_ACCESS_KEY_ID` & `AWS_SECRET_ACCESS_KEY` environment variables are set. This is required to allow Serverless to deploy the infrastructure to AWS from your local machine.

From the `ui` directory:
```bash
cd ./ui
```

Checkout the ui repository:
```bash
REPO=saintybalboa/nextjs-demo COMMIT_HASH=main make checkout
```

Deploy:
```bash
BUCKET=serverless-demo-ui-bucket-dev DOMAIN_PREFIX=dev DOMAIN=msswebdevelopment.com API_BASE_URL=https://api-dev.msswebdevelopment.com REPO=saintybalboa/nextjs-demo make deploy
```

> **Please note:** It can take a few hours for the DNS changes of newly created domains to be updated across the Internet.

#### Removing

The UI infrastructure stack can also be be removed from a specific domain in AWS.
From the `ui` directory run:
```bash
BUCKET=serverless-demo-ui-bucket-dev make remove
```

> **Important:** This will only remove the domain names and disable the CloudFront distribution. The CloudFront distribution will need to be deleted via the AWS console.

### API

Deploy the [AWS API Gateway Demo](https://github.com/saintybalboa/aws-api-gateway-demo) to a custom domain in AWS.

Create certificate:
```bash
DOMAIN=api-dev.msswebdevelopment.com HOSTED_ZONE_ID=XXXX CERT_REGION=us-east-1 make create-cert
```

Deploy:
```bash
DOMAIN=api-dev.msswebdevelopment.com REPO=saintybalboa/aws-api-gateway-demo HOSTED_ZONE_ID=XXXX make deploy
```

#### Removing

From the `api` directory remove:
```bash
DOMAIN=api-dev.msswebdevelopment.com REPO=saintybalboa/aws-api-gateway-demo HOSTED_ZONE_ID=Z2L1O1C41SKPHI make remove
```

> **Please note:** It can take up to 40 minutes to delete the stack in AWS and remove the domain. The certificate cannot be removed until this process is complete.

Remove certificate:
```bash
DOMAIN=api-dev.msswebdevelopment.com HOSTED_ZONE_ID=Z2L1O1C41SKPHI CERT_REGION=us-east-1 make remove-cert
```

