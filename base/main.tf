provider "aws" {
   alias                   = "${var.environment}"
   profile                 = "${var.environment}"
   shared_credentials_file = "$HOME/.aws/credentials" ## Needs aws cli configured. Please check readme.md
   region                  = "${var.aws_region}"
}

resource "aws_s3_bucket" "bucket" {
   provider                 = "aws.${var.environment}"
   bucket 	                 = "ENTER_YOUR_BUCKET_NAME"
   versioning {
     enabled = "true"
   }
   lifecycle {
     prevent_destroy = "true"
   }
   server_side_encryption_configuration {
     rule {
       apply_server_side_encryption_by_default {
         kms_master_key_id = "${aws_kms_key.key.arn}"
         sse_algorithm     = "aws:kms"
       }
     }
   }
}

resource "aws_kms_key" "key" {
   provider = "aws.${var.environment}"
   description = "This key is used to encrypt bucket objects"
}
