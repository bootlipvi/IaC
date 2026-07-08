# Partial backend configuration — the bucket is created by ../bootstrap
# (run that config first and note its `state_bucket_name` output).
#
# Initialize this config with:
#
#   terraform init \
#     -backend-config="bucket=<state_bucket_name output from bootstrap>" \
#     -backend-config="key=zippy-quotes-api/terraform.tfstate" \
#     -backend-config="region=<aws_region>"
#
# `use_lockfile` requires Terraform >= 1.11 (native S3 state locking, no
# DynamoDB table needed). On older Terraform, drop `use_lockfile`, add a
# `aws_dynamodb_table` (billing_mode = "PAY_PER_REQUEST") to bootstrap/, and
# pass -backend-config="dynamodb_table=<name>" instead.
terraform {
  backend "s3" {
    encrypt      = true
    use_lockfile = true
  }
}
