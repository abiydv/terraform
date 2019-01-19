variable "aws_region" {
  type        = "string"
  description = "AWS Region to use"
  default     = "us-east-1"     # Replace with AWS region of your choice
}

variable "aws_account_id" {
  description = "AWS account (dev/preprod/prod)"
  type        = "map"

  default = {
    tools   =   112233445566      # Replace with your AWS account id
    dev     =   112233445566      # Replace with your AWS account id
    qa      =   112233445566      # Replace with your AWS account id
    prod    =   112233445566      # Replace with your AWS account id
  }
}

variable "environment" {
  description = "Environment for resources"
  default     = "tools"
}
