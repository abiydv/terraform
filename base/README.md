# Base

Use this to initialize the basic resources to be used by Terraform. These are tracked separately from the main executions which use the remote backend and DB (for locking) created as part of this execution.

The tfstate file can subsequently be saved in s3 for future reference.
