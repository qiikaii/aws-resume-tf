# Export the bucket domain for CloudFront
output "s3_bucket_domain_name" {
  value = aws_s3_bucket.resume-bucket.bucket_regional_domain_name
}

# Export the bucket id for CloudFront
output "s3_bucket_id" {
  value = aws_s3_bucket.resume-bucket.id
}

# Export the bucket id for CloudFront
output "s3_bucket_arn" {
  value = aws_s3_bucket.resume-bucket.arn
}