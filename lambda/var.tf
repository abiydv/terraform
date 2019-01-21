variable "aws_region" {
  type = "string"
}
variable "aws_profile" {
  type = "string"
}
variable "environment" {
  type = "string"
}
variable "role" {
  type = "string"
}
variable "retention" {
}
variable "team_email" {
  type = "string"
}
variable "backup_rate" {
  type    = "string"
  default = "rate(12 hours)"
}
variable "cleanup_rate" {
  type    = "string"
  default = "rate(1 day)"
}
variable "backup_enabled" {
  type    = "string"
  default = "false"
}
variable "cleanup_enabled" {
  type    = "string"
  default = "false"
}
