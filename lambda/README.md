# AWS Lambda Functions
![terraform](https://github.com/abiydv/ref-docs/blob/master/images/logos/terraform_small.png)
![lambda](https://github.com/abiydv/ref-docs/blob/master/images/logos/aws-lambda_small.png)
![sns](https://github.com/abiydv/ref-docs/blob/master/images/logos/aws-sns_small.png)
![events](https://github.com/abiydv/ref-docs/blob/master/images/logos/aws-cwevent_small.png)
![iamrole](https://github.com/abiydv/ref-docs/blob/master/images/logos/aws-iamrole_small.png)

Use these templates to create Lambda functions for snapshot backup and cleanup stratergy. This is not configured to use S3 backend.

## Prerequisites
Download the source code for lambda functions in `../code/` from [here](https://github.com/abiydv/python/tree/master/ebs-snapshot-backup). Once downloaded, zip the individual functions and append the environment name. Following commands assume the `environment = production`, replace the values suitably before execution.

```
mkdir code && cd code
wget https://github.com/abiydv/python/archive/master.zip
unzip -p master.zip python-master/ebs-snapshot-backup/ebs-snapshot-backup.py > ./production-ebs-snapshot-backup.py
unzip -p master.zip python-master/ebs-snapshot-backup/ebs-snapshot-cleanup.py > ./production-ebs-snapshot-cleanup.py
zip production-ebs-snapshot-backup.zip production-ebs-snapshot-backup.py
zip production-ebs-snapshot-cleanup.zip production-ebs-snapshot-cleanup.py
```

## How to use
Once the source code is in place, execute the Terraform template to create the Lambdas, SNS topic, Cloudwatch events etc.
```
cd ../lambda/
terraform init
terraform plan
terraform apply
```

## Contact
Drop me a note or open an issue if something doesn't work out.

Cheers! :thumbsup:
