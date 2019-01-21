resource "aws_cloudwatch_event_rule" "event_rule" {
  name        = "${var.rule_name}"
  description = "${var.description}"
  schedule_expression = "${var.rate}"
  is_enabled = "${var.isenabled}"
}

resource "aws_cloudwatch_event_target" "event_target" {
  target_id  = "event_target"
  rule = "${aws_cloudwatch_event_rule.event_rule.name}"
  arn  = "${var.target_arn}"
  input = "${data.template_file.target-input.rendered}"
}

output "event_arn" {
  value = "${aws_cloudwatch_event_rule.event_rule.arn}"
}
