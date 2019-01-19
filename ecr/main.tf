provider "aws" {
  alias	  = "${var.environment}"
  profile = "${var.environment}"
  shared_credentials_file = "$HOME/.aws/credentials"
  region                  = "${var.aws_region}"
}

terraform {
  backend "s3" {
    bucket  = "S3_BUCKET"        # Replace with the s3 bucket create earlier with the terraform/base stack
    key     = "tools/statefile"
    region  = "REGION"           # Replace with the AWS region of your choice
    encrypt = true
    profile = "tools"
  }
}

data "template_file" "ecr_repo_policy" {
  template = "${file("${path.module}/templates/ecr-iam-policy.json.tpl")}"

  vars {
    aws_tools_account_id = "${var.aws_account_id["tools"]}"   # This account hosts the repo and has complete access
    aws_dev_account_id   = "${var.aws_account_id["dev"]}"     # This account will be allowed to pull images from this repo
    aws_qa_account_id    = "${var.aws_account_id["qa"]}"      # This account will be allowed to pull images from this repo
    aws_prod_account_id  = "${var.aws_account_id["prod"]}"    # This account will be allowed to pull images from this repo
    aws_region           = "${var.aws_region}"
    ecr_repo_name        = "${aws_ecr_repository.ecr_repo.name}"
  }
}

resource "aws_ecr_repository" "ecr_repo" {
  provider = "aws.${var.environment}"
  name     = "REPO_NAME"                      # Replace with name of your choice
}

resource "aws_ecr_repository_policy" "ecr_repo_policy" {
  provider   = "aws.${var.environment}"
  repository = "${aws_ecr_repository.ecr_repo.name}"
  policy     = "${data.template_file.ecr_repo_policy.rendered}"
}
