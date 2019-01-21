# Terraform [![Codacy Badge](https://api.codacy.com/project/badge/Grade/8d1372eabf874e0f922bb41508862cb6)](https://www.codacy.com/app/abi5090/terraform?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=abiydv/terraform&amp;utm_campaign=Badge_Grade)
Terraform examples and modules

## Prerequisites
Configure AWS Cli access for all the AWS accounts you want to work with. You can skip this if you want to create the stacks from the Cloudformation console.

Example for configuring **tools** account. Repeat similarly for **dev**, **qa**, **prod** accounts. 
```
$ aws configure --profile tools
AWS Access Key ID [None]: ACCESS_KEY
AWS Secret Access Key [None]: SECRET_KEY
Default region name [None]: us-east-1
Default output format [None]:
```
Once done, these profiles should be available for use with aws cli - 
```
tools
dev
qa
prod
```

## What is where?

### [Base](./base)
To create a S3 bucket for use as Terraform remote backend. Execute this first, to setup the resources that are required for using the S3 backend. For details, please refer to the readme in the sub-directory.

### [AWS ECR](./ecr)
To create an AWS ECR repo, for use with the AWS ECS cluster. For details, please refer to the readme in the sub-directory.

### [AWS ECS](./ecs)
To create a ECS Fargate cluster with auto-scaling, application load balancer and other related resources. For details, please refer to the readme in the sub-directory.

### [AWS Lambda](./lambda)
To create Lambda functions for taking periodic snapshots of suitably tagged EBS volumes. Also cleans up snapshots older than 90 days. This module is useful for deploying the lambda function and the resources it needs to function. The source code for lambda is in my other repo [here](https://github.com/abiydv/python/tree/master/ebs-snapshot-backup).
<br> Uses modules/ and templates/
