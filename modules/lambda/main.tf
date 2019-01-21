resource "aws_lambda_function" "lambda" {
  function_name    = "${var.function_name}"
  description      = "${var.description}"
  filename         = "${var.filename}"
  role             = "${var.role_arn}"
  handler          = "${var.handler}"
  runtime          = "${var.runtime}"
  timeout          = "${var.timeout}"
}

resource "aws_lambda_permission" "allow_invoke" {
  statement_id   = "allowInvoke"
  action         = "lambda:InvokeFunction"
  function_name  = "${aws_lambda_function.lambda.function_name}"
  principal      = "${var.trigger_service}"
  source_arn     = "${var.trigger_service_arn}"
}

output "lambda_arn" {
   value = "${aws_lambda_function.lambda.arn}"
}
