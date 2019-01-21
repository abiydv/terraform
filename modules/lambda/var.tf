variable "function_name" {
  description = "Name of the function"
}
variable "description" {
  description = "Purpose of the function"
}
variable "filename" {
  description = "Local location of function code"
}
variable "role_arn" {
  description = "IAM role of function"
}
variable "handler" {
  description = "Entrypoint of function",
  default = "lambda_handler"
}
variable "runtime" {
  description = "Runtime of the function",
  default = "python3.6"
}
variable "timeout" {
  description = "Timeout duration of the function",
  default = "300"
}
variable "trigger_service" {
  description = "This service will trigger lambda"
}
variable "trigger_service_arn" {
  description = "This service will trigger lambda"
}
