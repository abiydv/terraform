# Base

![terraform](https://github.com/abiydv/ref-docs/blob/master/images/logos/terraform_small.png)
![aws-cli](https://github.com/abiydv/ref-docs/blob/master/images/logos/aws-cli_small.png)
![aws-kms](https://github.com/abiydv/ref-docs/blob/master/images/logos/aws-kms_small.png)
![aws-s3](https://github.com/abiydv/ref-docs/blob/master/images/logos/aws-s3_small.png)

Use this to initialize the basic resources to be used by Terraform. These are tracked separately from the main executions which use the remote backend and DB (for locking) created as part of this execution.

Ideally, you will not need to run this more than once. The generated `terraform.tfstate` file can subsequently be saved in s3 for future reference. 

## Prerequisites
As described in this [readme](https://github.com/abiydv/terraform/blob/master/README.md), aws cli should be setup and ready for use for the accounts you want to work with.

## How to use
Follow these steps after cloning the repository

```
cd base
terraform init
terraform plan
terraform apply
```

### Optional
Not required, but recommended in case you lose your current installation path. Easy to retrieve from S3 and run subsequent terraform commands.

```
aws s3 cp terraform.tfstate s3://YOUR_BUCKET_NAME/base/terraform.tfstate --profile tools --region REGION
```
