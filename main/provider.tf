# When var.use_localstack is true, requests are redirected to a local
# LocalStack container instead of real AWS (see variables.tf). This is for
# offline testing only; leave use_localstack at its default (false) for a
# real deployment.
provider "aws" {
  region = var.aws_region

  access_key = var.use_localstack ? "test" : null
  secret_key = var.use_localstack ? "test" : null

  s3_use_path_style           = var.use_localstack
  skip_credentials_validation = var.use_localstack
  skip_metadata_api_check     = var.use_localstack
  skip_requesting_account_id  = var.use_localstack

  endpoints {
    apigateway   = var.use_localstack ? var.localstack_endpoint : null
    apigatewayv2 = var.use_localstack ? var.localstack_endpoint : null
    lambda       = var.use_localstack ? var.localstack_endpoint : null
    iam          = var.use_localstack ? var.localstack_endpoint : null
    s3           = var.use_localstack ? var.localstack_endpoint : null
    sts          = var.use_localstack ? var.localstack_endpoint : null
    logs         = var.use_localstack ? var.localstack_endpoint : null
  }

  default_tags {
    tags = local.common_tags
  }
}
