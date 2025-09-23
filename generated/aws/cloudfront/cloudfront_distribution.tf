resource "aws_cloudfront_distribution" "tfer--E88GX7I0XDPAZ" {
  aliases = ["resume.sidpanic.io"]

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cache_policy_id = "09c3caca-1280-44cb-bbbf-2dd8ebaaf9fc"
    cached_methods  = ["GET", "HEAD"]
    compress        = "true"
    default_ttl     = "0"

    grpc_config {
      enabled = "false"
    }

    max_ttl                    = "0"
    min_ttl                    = "0"
    origin_request_policy_id   = "5f6280ba-27b8-48a6-bc2c-d2237218c557"
    response_headers_policy_id = "ab14d56b-552c-4128-8fac-21fc0a550fb4"
    smooth_streaming           = "false"
    target_origin_id           = "qikai-aws-resume.s3.ap-southeast-1.amazonaws.com"
    viewer_protocol_policy     = "redirect-to-https"
  }

  default_root_object = "index.html"
  enabled             = "true"
  http_version        = "http2and3"
  is_ipv6_enabled     = "false"

  ordered_cache_behavior {
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cache_policy_id = "09c3caca-1280-44cb-bbbf-2dd8ebaaf9fc"
    cached_methods  = ["GET", "HEAD", "OPTIONS"]
    compress        = "true"
    default_ttl     = "0"

    grpc_config {
      enabled = "false"
    }

    max_ttl                    = "0"
    min_ttl                    = "0"
    origin_request_policy_id   = "5f6280ba-27b8-48a6-bc2c-d2237218c557"
    path_pattern               = "/*"
    response_headers_policy_id = "ab14d56b-552c-4128-8fac-21fc0a550fb4"
    smooth_streaming           = "false"
    target_origin_id           = "qikai-aws-resume.s3.ap-southeast-1.amazonaws.com"
    viewer_protocol_policy     = "redirect-to-https"
  }

  origin {
    connection_attempts      = "3"
    connection_timeout       = "10"
    domain_name              = "qikai-aws-resume.s3.ap-southeast-1.amazonaws.com"
    origin_access_control_id = "E1COEL7APVQTZ9"
    origin_id                = "qikai-aws-resume.s3.ap-southeast-1.amazonaws.com"
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  retain_on_delete = "false"
  staging          = "false"

  tags = {
    Name = "CloudFront - Resume Demo s3"
  }

  tags_all = {
    Name = "CloudFront - Resume Demo s3"
  }

  viewer_certificate {
    acm_certificate_arn            = "arn:aws:acm:us-east-1:318689658132:certificate/358ee709-ff12-46fa-aa78-6bc78a41d2c4"
    cloudfront_default_certificate = "false"
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }
}
