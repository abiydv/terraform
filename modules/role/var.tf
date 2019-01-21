variable "role_name" {
  description = "Name of the role"
}
variable "policy_name" {
  description = "Name of the policy"
}
variable "role_policy" {
   description = "Policy for role"
}
variable "assume_role_policy" {
   description = "Assume role policy for role"
}
variable "topic_arn" {
   description = "Topic Arn"
}
data "template_file" "assume_role_policy" {
   template = "${file("${path.module}/../templates/${var.assume_role_policy}")}"
}
data "template_file" "role_policy" {
   template = "${file("${path.module}/../templates/${var.role_policy}")}"
   vars {
     topic_arn = "${var.topic_arn}"
   }
}
