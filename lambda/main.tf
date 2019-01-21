provider "aws" {
    shared_credentials_file = "$HOME/.aws/credentials"
    profile                 = "${var.aws_profile}"
    region                  = "${var.aws_region}"
}

module "backup_lambda" {
   source              = "${path.module}/../modules/lambda"
   function_name       = "${var.environment}_backup_lambda_function"
   description         = "Takes snapshots of ${var.role} volumes"
   filename            = "${path.module}/../code/${var.environment}-ebs-snapshot-backup.zip"
   handler             = "${var.environment}-ebs-snapshot-backup.lambda_handler"
   role_arn            = "${module.lambda_role.role_arn}"
   trigger_service     = "events.amazonaws.com"
   trigger_service_arn = "${module.backup_event.event_arn}"
}

module "cleanup_lambda" {
   source              = "${path.module}/../modules/lambda"
   function_name       = "${var.environment}_cleanup_lambda_function"
   description         = "Removes ${var.retention} days old snapshot(s) of ${var.role} volumes"
   filename            = "${path.module}/../code/${var.environment}-ebs-snapshot-cleanup.zip"
   handler             = "${var.environment}-ebs-snapshot-cleanup.lambda_handler"
   role_arn            = "${module.lambda_role.role_arn}"
   trigger_service     = "events.amazonaws.com"
   trigger_service_arn = "${module.cleanup_event.event_arn}"
}

module "lambda_role" {
   source             = "${path.module}/../modules/role"
   role_name          = "${var.environment}_lambda_role"
   policy_name        = "${var.environment}_lambda_role_policy"
   topic_arn          = "${module.sns.topic_arn}"
   role_policy        = "role-policy.json"
   assume_role_policy = "assume-role-policy.json"
}

module "backup_event" {
   source            = "${path.module}/../modules/event"
   rule_name         = "${var.environment}_backup_event"
   target_arn        = "${module.backup_lambda.lambda_arn}"
   topic_arn         = "${module.sns.topic_arn}"
   target_input_json = "event-input.json"
   description       = "Triggers ${var.environment} backup lambda"
   rate              = "${var.backup_rate}"
   isenabled         = "${var.backup_enabled}"
}

module "cleanup_event" {
   source            = "${path.module}/../modules/event"
   rule_name         = "${var.environment}_cleanup_event"
   target_arn        = "${module.cleanup_lambda.lambda_arn}"
   target_input_json = "event-input.json"
   topic_arn         = "${module.sns.topic_arn}"
   description       = "Triggers ${var.environment} cleanup lambda"
   rate              = "${var.cleanup_rate}"
   isenabled         = "${var.cleanup_enabled}"
}

module "sns" {
   source          = "${path.module}/../modules/sns"
   topic_name      = "${var.environment}_notify_team"
   team_email      = "${var.team_email}"
   aws_profile     = "${var.aws_profile}"
   aws_region      = "${var.aws_region}"
}
