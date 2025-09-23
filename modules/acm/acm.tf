resource "aws_acm_certificate" "cloudfront-cert" {
  provider              = aws.region-us-east-1    
  domain_name           = "resume.sidpanic.io"
  validation_method     = "DNS"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_acm_certificate" "api-gateway-cert" {
  domain_name           = "api.resume.sidpanic.io"
  validation_method     = "DNS"

  lifecycle {
    prevent_destroy = true
  }
}