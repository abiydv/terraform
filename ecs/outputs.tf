output "public_url" {
	value = "${aws_route53_record.default.name}"
}
