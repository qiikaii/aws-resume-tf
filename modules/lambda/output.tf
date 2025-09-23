output "lambda_resumecounter_invoke_arn" {
  value = aws_lambda_function.lambda_resumecounter.invoke_arn
}

output "lambda_resumecounter_function_name" {
  value = aws_lambda_function.lambda_resumecounter.function_name  
}