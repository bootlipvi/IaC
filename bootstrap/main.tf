data "aws_caller_identity" "current" {}

locals {
  state_bucket_name = "zippy-quotes-tfstate-${data.aws_caller_identity.current.account_id}"

  common_tags = {
    Project     = "zippy-quotes"
    Environment = "demo"
    ManagedBy   = "terraform"
    Purpose     = "terraform-state"
  }
}

# This bucket is bootstrapped with local state because it cannot describe the
# backend it will later serve for ../main. Apply this config once, then wire
# its output into ../main's backend configuration.
resource "aws_s3_bucket" "tfstate" {
  bucket = local.state_bucket_name

  lifecycle {
    prevent_destroy = true
  }

  tags = local.common_tags
}

resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
