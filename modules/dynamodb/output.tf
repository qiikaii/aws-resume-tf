output "dynamodb_id" {
  value = aws_dynamodb_table.resume-visitors-sessions.id
}

output "dynamodb_arn" {
   value = aws_dynamodb_table.resume-visitors-sessions.arn  
}

output "dynamodb_name" {
  value = var.dynamodb_name
}