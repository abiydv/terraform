resource "aws_sns_topic" "sns_topic" {
  name = "${var.topic_name}"
  provisioner "local-exec" {
     command = "aws --profile ${var.aws_profile} sns subscribe --region ${var.aws_region} \
     --topic-arn ${self.arn} --protocol email --notification-endpoint ${var.team_email}"
     }
 }

output "topic_arn" {
   value = "${aws_sns_topic.sns_topic.arn}"
}
