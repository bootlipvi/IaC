output "api_endpoint" {
  description = "Base URL of the deployed API Gateway HTTP API"
  value       = aws_apigatewayv2_stage.default.invoke_url
}

output "lambda_function_name" {
  description = "Name of the deployed Lambda function"
  value       = module.lambda_function.lambda_function_name
}
