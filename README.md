# Serverless demo

Defines an AWS infrastructure for the following services:

- [Email](./docs/email.md): AWS SES
- [API](./docs/api.md): AWS API Gateway
- [UI](./docs/ui.md): AWS S3 & Lambda@Edge with Cloudfront

## Instructions

Create a public hosted zone in AWS Route 53 to route traffic for a your custom domain.

Supports the node version specified in [.nvmrc](.nvmrc)

## Deployments

Github workflows are used for the automated & manual deployments of services within the Serverless Demo infrastructure. A Github personal access token has been setup to provide Serverless Demo infrastructure builds access to the other repositories. `DEV_AWS_ACCESS_KEY_ID`, `DEV_AWS_SECRET_ACCESS_KEY`, `PROD_AWS_ACCESS_KEY_ID` & `PROD_AWS_SECRET_ACCESS_KEY` environment variables are set from Github secrets to allow Serverless to deploy the infrastructure to each AWS environment from Github.


## Local development

Manual deployments can also be carried out on your local machine.

Ensure [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-mac.html) is installed on your local machine and that the `AWS_ACCESS_KEY_ID` & `AWS_SECRET_ACCESS_KEY` environment variables are set. This is required to allow Serverless to deploy the infrastructure to AWS from your local machine.

Set the access token for authenticating against the Github package registry.
```bash
export NPM_AUTH_TOKEN=XXXX
```

Install dependencies:
```bash
npm i
npm i -g serverless
```

See the following documentation for further instructions on how to deploy a specific service:

- [Email](./docs/email.md)
- [API](./docs/api.md)
- [UI](./docs/ui.md)
