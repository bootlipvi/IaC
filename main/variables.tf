variable "aws_region" {
  description = "AWS region to deploy the Lambda and API Gateway into"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used as a prefix for resource names and tags"
  type        = string
  default     = "zippy-quotes"

  validation {
    condition     = length(var.project_name) > 0 && length(var.project_name) <= 32
    error_message = "project_name must be 1-32 characters."
  }
}

variable "environment" {
  description = "Deployment environment label"
  type        = string
  default     = "demo"

  validation {
    condition     = contains(["demo", "staging", "production"], var.environment)
    error_message = "environment must be one of: demo, staging, production."
  }
}

variable "use_localstack" {
  description = "Point the AWS provider at a local LocalStack endpoint instead of real AWS, for offline testing"
  type        = bool
  default     = false
}

variable "localstack_endpoint" {
  description = "LocalStack gateway endpoint (only used when use_localstack is true)"
  type        = string
  default     = "http://localhost:4566"
}

variable "lambda_architectures" {
  description = "Lambda instruction set architecture. Real deployments use arm64 (Graviton, cheaper); LocalStack's Docker-based Lambda executor cannot emulate arm64 on an amd64 Docker host, so local testing overrides this to x86_64."
  type        = list(string)
  default     = ["arm64"]
}
