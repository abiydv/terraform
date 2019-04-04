# AWS Elastic Container Service Cluster (Fargate)

![terraform](https://github.com/abiydv/ref-docs/blob/master/images/logos/terraform_small.png)
![elb](https://github.com/abiydv/ref-docs/blob/master/images/logos/aws-elb_small.png)
![cw-alarm](https://github.com/abiydv/ref-docs/blob/master/images/logos/aws-cwalarm_small.png)
![autoscaling](https://github.com/abiydv/ref-docs/blob/master/images/logos/aws-autoscaling_small.png)
![ecs-fargate](https://github.com/abiydv/ref-docs/blob/master/images/logos/aws-ecs-fargate_small.png)
![r53](https://github.com/abiydv/ref-docs/blob/master/images/logos/aws-r53_small.png)

Use this Terraform template to create a AWS ECS cluster (Fargate). Along with ECS, it also creates some other resources the ECS cluster needs, like - elastic load balancer, auto-scaling policies, cloudwatch alarms, route 53 entries etc.

## Architecture
A simplified view of the architecture is as follows - 
![arch](https://github.com/abiydv/ref-docs/blob/master/images/arch/ARCH_GH.png)

## Prerequisites
While this module creates most of the resources ECS needs, there are a few resources it expects to exist.
Following must exist in the account - 
 - VPC with 2 public and 2 private subnets tagged Tier:Public, Tier:Private (can be created using cloudformation template [vpc-stack](https://github.com/abiydv/cloudformation/tree/master/vpc))
 - ACM certificate for the Load balancer 443 listener
 - ECR Repository (can be created using [ecr](https://github.com/abiydv/terraform/tree/master/ecr) module)
 - An IMAGE:TAG combination in the ECR repository

## How to use

Checkout the repository, modify the values as indicated in the files, and execute the base template first to create a S3 backend
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

## Alternative
You could also create the same set of resources using Cloudformation, if you prefer. Take a look at [this](https://github.com/abiydv/cloudformation/tree/master/ecs)

## Contact
Drop me a note or open an issue if something doesn't work out. 

Cheers! :thumbsup:
