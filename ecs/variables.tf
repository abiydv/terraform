variable "aws_account_id" {
  description = "AWS account (tools/dev/qa/prod)"
  type        = "map"
  default = {
    tools   =   112233445566
    dev     =   112233445566
    qa      =   112233445566
    prod    =   112233445566
  }
}

variable "aws_region" {
  type        = "string"
  description = "AWS Region to use"
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "Enter VPC to use (tools/dev/qa/prod)"
  type        = "map"
  default   = {
    tools   =   "vpc-0123abc456def7890"
    dev     =   "vpc-0123abc456def7890"
    qa      =   "vpc-0123abc456def7890"
    prod    =   "vpc-0123abc456def7890"
  }
}

variable "hosted_zone" {
  description = "Hosted Zone"
  type        = "map"

  default   = {
    dev     =   "dev.example.com"
    qa      =   "qa.example.com"
    prod    =   "prod.example.com"
  }
}

variable "endpoint" {
  description = "Final endpoint for the application, prefix of hosted_zone"
}

variable "app_image" {
  description = "Docker image to run in the ECS cluster"
  default     = "REPO_URL/IMAGE:TAG"         # Replace REPO_URL from output of ECR stack
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 80
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 1
}

variable "health_check_path" {
  description = "Health check path for ALB"
  default = "/"
}

variable "lb_cert_name" {
  description = "ACM cert name to be used with ALB"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "1024"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "2048"
}

variable "environment" {
  description = "Environment for resources"
}

variable "container_env_value" {
  description = "Environment specific value for container, replaced at runtime"
}

variable "ecs_as_cpu_low_threshold_per" {
  description = "Low CPU threshold to scale down containers"
  default     = "20"
}

variable "ecs_as_cpu_high_threshold_per" {
  description = "High CPU threshold to scale up containers"
  default     = "80"
}

variable "ecs_as_min_containers" {
  description = "Minimum number of containers to run"
  default     = "1"
}

variable "ecs_as_max_containers" {
  description = "Maximum number of containers to run. Autoscaling will not launch more than this number"
  default     = "4"
}
