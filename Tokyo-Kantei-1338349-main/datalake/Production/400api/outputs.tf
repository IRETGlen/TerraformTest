output "aws_api_gateway_rest_api" {
  description = "The ID of the API Gateway deployed."
  value       = aws_api_gateway_rest_api.api.id
}

output "aws_api_gateway_rest_api_execution_arn" {
  description = "The execution arn of the API Gateway deployed."
  value       = aws_api_gateway_rest_api.api.execution_arn
}
