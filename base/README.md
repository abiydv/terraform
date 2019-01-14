# Base

Use this to initialize the basic resources to be used by Terraform. These are tracked separately from the main executions which use the remote backend and DB (for locking) created as part of this execution.

Ideally, you will not need to run this more than once. The generated `terraform.tfstate` file can subsequently be saved in s3 for future reference. 

## Prerequisites
1. [Install AWS cli](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
2. [Configure AWS cli](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)

Note: Configure the "profile" in AWS Cli after the environment of the account. Example for setting up a "tools" profile -
```
$ aws configure --profile tools
AWS Access Key ID [None]: ACCESS_KEY
AWS Secret Access Key [None]: SECRET_KEY
```
 The above will result in a `~/.aws/credentials` file looking like - 
```
[tools]
aws_access_key_id = ACCESS_KEY
aws_secret_access_key = SECRET_KEY
```
We are now ready to use terraform with this "tools" profile.

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
