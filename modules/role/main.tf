resource "aws_iam_role" "iam_role" {
  name = "${var.role_name}"
  assume_role_policy = "${data.template_file.assume_role_policy.rendered}"
}

resource "aws_iam_role_policy" "iam_role_policy" {
   name   = "${var.policy_name}"
   role   = "${aws_iam_role.iam_role.id}"
   policy = "${data.template_file.role_policy.rendered}"
}

output "role_arn" {
  value = "${aws_iam_role.iam_role.arn}"
}
