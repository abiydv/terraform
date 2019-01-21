variable "rule_name" {
  description = "Name of the rule"
}
variable "description" {
  description = "Purpose of the rule"
}
variable "rate" {
  description = "Cron expression"
  default = "rate(1 day)"
}
variable "isenabled" {
  default = false
}
variable "target_arn" {
  description = "Target ARN"
}
variable "topic_arn" {
  description = "Topic ARN"
}
variable "target_input_json" {
  description = "Input Json"
}
data "template_file" "target-input" {
  template = "${file("${path.module}/../templates/${var.target_input_json}")}"
  vars {
    topic_arn = "${var.topic_arn}"
  }
}
