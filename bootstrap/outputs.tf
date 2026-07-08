output "state_bucket_name" {
  description = "Name of the S3 bucket holding Terraform state; use this value when initializing ../main's backend"
  value       = aws_s3_bucket.tfstate.id
}
