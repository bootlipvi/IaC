data "archive_file" "zippy_lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/../build/zippy_lambda.zip"

  source {
    content  = file("${path.module}/../src/lambda_handler.py")
    filename = "lambda_handler.py"
  }

  source {
    content  = file("${path.module}/../src/zippy/__init__.py")
    filename = "zippy/__init__.py"
  }

  source {
    content  = file("${path.module}/../src/zippy/quotes.py")
    filename = "zippy/quotes.py"
  }
}

module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 7.0"

  function_name = local.lambda_name
  description   = "Returns a random Zippy the Pinhead quote as HTML or JSON"
  handler       = "lambda_handler.handler"
  runtime       = "python3.12"
  architectures = var.lambda_architectures
  memory_size   = 128
  timeout       = 5

  create_package         = false
  local_existing_package = data.archive_file.zippy_lambda_zip.output_path

  cloudwatch_logs_retention_in_days = 14

  tags = local.common_tags
}

resource "aws_apigatewayv2_api" "zippy_quotes" {
  name          = "${var.project_name}-http-api"
  protocol_type = "HTTP"

  tags = local.common_tags
}

resource "aws_apigatewayv2_integration" "lambda" {
  api_id                 = aws_apigatewayv2_api.zippy_quotes.id
  integration_type       = "AWS_PROXY"
  integration_method     = "POST"
  integration_uri        = module.lambda_function.lambda_function_invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "root" {
  api_id    = aws_apigatewayv2_api.zippy_quotes.id
  route_key = "GET /"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

resource "aws_apigatewayv2_route" "api_quote" {
  api_id    = aws_apigatewayv2_api.zippy_quotes.id
  route_key = "GET /api/quote"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.zippy_quotes.id
  name        = "$default"
  auto_deploy = true

  tags = local.common_tags
}

resource "aws_lambda_permission" "apigw_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_function.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.zippy_quotes.execution_arn}/*/*"
}
