# AWS Elastic Container Service

Use this to create a ECS (Fargate) cluster on AWS.

## Prerequisites
While this module creates most of the resources ECS needs, there are a few resources it expects to exist.
Following must exist in the account - 
 - VPC with 2 public and 2 private subnets tagged Tier:Public, Tier:Private 
 - ACM certificate for the Load balancer 443 listener
 - ECR Repository (can be created using [ecr](https://github.com/abiydv/terraform/tree/master/ecr) module)
 - An IMAGE:TAG combination in the ECR repository

## How to use

Checkout the repository, modify the values as indicated in the files, and execute the base template first create a S3 backend
```
cd base
terraform init
terraform plan
terraform apply
```
Next, create the ECR repo 
```
cd ecr
terraform init
terraform plan
terraform apply
```
Finally, create the ECS stack
```
cd ecs
terraform init
terraform plan
terraform apply
```


Drop me a note or open an issue if something doesn't work out. 

Cheers! :thumbsup: