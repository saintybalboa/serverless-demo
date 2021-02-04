# Email

Deploys a stack to configure AWS SES to enable the sending and receiving of mail from email addresses associated with a Markitool domain. This allows custom email addresses (e.g. `no-reply@notifications.dev.example.com`) to be used as the sender via AWS services such as Cognito.

## How it works

1. Incoming mail forwarder: Using the Serverless framework an SNS Topic & Subscription are created to allow the forwarding of incoming mail to an active email account (e.g. `dev@example.com` provided by GMAIL).

2. SNS Subscription: AWS emails a confirmation link to the active email account. This link must be visited to allow the mail to be forwarded to the active email account.

3. Email sender addresses: Using the [Serverless AWS SES](https://github.com/saintybalboa/serverless-aws-ses) the relevant dns records are created and AWS SES configuration applied to allow incoming and outgoing mail for the custom email addresses.

4. Mail forwarding: A ruleset is created in AWS SES, assigning the SNS Topic as an action to allow the forwarding of incoming email to an active email account.

5. Email Verification: AWS emails a verification link to each email sender address. The SNS subscription forwards the email on to the active email account. The link must be visited in order to active the email address for use in AWS SES.

## Manual deployments

A [Github Action](./.github/workflows/email-manual-deploy.yml) has been setup to allow manual deployments to dev and prod environments.

> **Important:** AWS will attempt to send a verification link to each email address you attempt to add to SES. You are required to visit the link in order to active the email address. You won't have access to incoming email at this point, so you'll need to setup an action for incoming email.

An SNS Topic/Subscription stack is also defined the [Serverless deployment template](./email/serverless) to forward incoming email for the sender email address (`no-reply@notifications.dev.example.com`) to an active email address (e.g. `dev@example.com`). This allows us to access the email with a verification link. You will receive an initial email to confirm the SNS subscription on the active email account. It is important you click on the confirmation link before the deployment has finished. A verification email will then be sent to the email address added to SES and forwarded to the active email address. The email body will consist of a json encoded string, embeddeding a verification url. Copy the verification URL and open it in a browser to confirm the email address.

Deploy stack to AWS:
```bash
cd email &&
ENV=dev HOSTED_ZONE_ID=XXXX EMAIL_SENDER_DOMAIN="notifications.dev.example.com" EMAIL_SENDER_ALIAS=no-reply FORWARD_EMAIL_ADDRESS=dev@example.com SNS_TOPIC_ARN=arn:aws:sns:us-east-1:$AWS_ACCOUNT_ID:ServerlessDemoEmailForwarder make deploy
```

## Removing

Remove stack from AWS:
```bash
cd ./ui &&
ENV=dev HOSTED_ZONE_ID=XXXX EMAIL_SENDER_DOMAIN="notifications.dev.example.com" EMAIL_SENDER_ALIAS=no-reply FORWARD_EMAIL_ADDRESS=dev@example.com SNS_TOPIC_ARN=arn:aws:sns:us-east-1:$AWS_ACCOUNT_ID:ServerlessDemoEmailForwarder make remove
```
