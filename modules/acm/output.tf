# Export the bucket domain for CloudFront
output "cloudfront_cert_arn" {
  value = aws_acm_certificate.cloudfront-cert.arn
}

# Export the bucket domain for CloudFront
output "api-gateway-cert_arn" {
  value = aws_acm_certificate.api-gateway-cert.arn
}