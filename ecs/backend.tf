terraform {
  backend "s3" {
    bucket   = "S3_BUCKET"        # Replace with bucket created with base module
    key      = "dev/statefile"    # Replace dev with actual env this is used for
    region   = "us-east-1"
    encrypt  = true
    profile  = "tools"
  }
}

# Terraform doesn't allow interpolation (yet) in the backend block. 
# Please ensure to change the "key" to keep the state of different environments separate.
# Used "dev" as an example here.
