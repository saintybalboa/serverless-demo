# UI

Deploys the [NextJS Demo](https://github.com/saintybalboa/nextjs-demo) web app to an AWS stack consisting of S3 with Lambda@Edge functions in every AWS CloudFront Edge location, assigned to custom domain.

## How it works

1. SSL certificate: Using the [Serverless Certificate Creator](https://github.com/schwamster/serverless-certificate-creator) plugin an SSL certificate is created specifically for the domain serving the UI.

2. Web app: The [Serverless Next.js Component](https://www.serverless.com/blog/serverless-nextjs) is used within the Serverless framework to deploy the web app to AWS Lambda@Edge functions in every AWS CloudFront Edge location.

3. Domain certificate: The Serverless component automatically checks and assign the relevant SSL certificate to the Cloudfront domain.

## Automated deployments

A [Github Action](./.github/workflows/ui-deploy.yml) has been setup to deploy the Markitool UI application stack to the development domain in AWS. This action uses the `repository_dispatch` event to allow the job to be triggered via the Github API. The [markitool-ui](https://github.com/Markitool-Team/markitool-ui) repo has a Github Action setup to trigger the event when changes are merged into it's `main` branch. As a result we get automated deployments to the development environment.

## Manual deployments

A [Github Action](./.github/workflows/ui-manual-deploy.yml) has been setup to allow deployments to the production domain in AWS to be triggered manually via the Github interface

> **Important:** Certificates must be created in the us-east region in order to be applied to a CloudFront distribution.

Create certificate:
```bash
ENV=dev DOMAIN=dev.example.com SUBJECT_ALTERNATIVE_NAME="dev.example.com" HOSTED_ZONE_ID=XXXX make create-cert
```

Checkout the UI repository:
```bash
REPO=saintybalboa/nextjs-demo COMMIT_HASH=main SERVICE=ui make checkout-repo
```

Deploy stack to AWS:
```bash
cd ./ui &&
BUCKET=markitool-ui-bucket-dev DOMAIN=example.com API_BASE_URL=https://api.dev.example.com REPO=saintybalboa/nextjs-demo make deploy
```

> **Please note:** It can take a few hours for the DNS changes of newly created domains to be updated across the Internet.

## Removing

The UI infrastructure stack can also be be removed from a specific domain in AWS.

Remove stack from AWS:
```bash
cd ./ui &&
BUCKET=markitool-ui-bucket-dev make remove
```

> **Important:** This will only remove the domain names and disable the CloudFront distribution. The CloudFront distribution will need to be deleted via the AWS console. It can take up to 40 minutes to disable the CloudFront distribution. The certificate cannot be removed until this process is complete.

Remove certificate:
```bash
ENV=dev DOMAIN=dev.example.com SUBJECT_ALTERNATIVE_NAME="dev.example.com" HOSTED_ZONE_ID=XXXX make remove-cert
```
