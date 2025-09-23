resource "aws_cloudfront_cache_policy" "cf_origin_cache_policy_allowcookies" {
    name            = "Cache_Policy-HeadersWhitelist-TF"
    comment         = "Cache policy created from Terraform"

    default_ttl     = 3600
    min_ttl         = 1
    max_ttl         = 36000

    parameters_in_cache_key_and_forwarded_to_origin {
        cookies_config {
          cookie_behavior = "all"
        }

        headers_config {
          header_behavior = "whitelist"
          headers {
            items = ["Authorization",
            "Origin"
            ]
          }
        }

        query_strings_config {
          query_string_behavior = "none"
        }
    }
}

resource "aws_cloudfront_origin_request_policy" "cf_origin_request_policy_allowcookies" {
    name              = "Origin_Request_Policy-AllowCookies-TF"
    comment           = "Origin request policy created from Terraform"

    cookies_config {
        cookie_behavior = "all"  # Do not forward cookies
    }

    headers_config {
        header_behavior = "whitelist"  # Only forward essential headers
        headers {
            items = [
            "Origin"                # Allow Origin header (useful for CORS)
            ]
        }
    }

    query_strings_config {
        query_string_behavior = "all"  # Forward all query strings
    }
}

resource "aws_cloudfront_response_headers_policy" "cf_response_header_policy_allowcors" {
    name                = "Response_Header_Policy-AllowCORS-TF"
    comment             = "Responsee header policy created from Terraform"
    
    cors_config {
        access_control_allow_credentials    = true

        access_control_allow_headers {
            items = ["Origin",
                "Authorization",
                "Content-Type",
                "Cookie"
            ]
        }
        
        access_control_allow_origins {
            items = ["resume.sidpanic.io",
                "api.resume.sidpanic.io"]
        }

        access_control_allow_methods {
            items = ["GET",
                "PUT",
                "OPTIONS"]
        }

        origin_override     = true
    }
}

resource "aws_cloudfront_origin_access_control" "origins3resume" {
    name                = "OriginAccess-S3Resume-TF"
    description         = "Origin Access created from Terraform"

    origin_access_control_origin_type = "s3"
    signing_behavior    = "always"
    signing_protocol    = "sigv4"
}

resource "aws_cloudfront_distribution" "cf_resume" {
    aliases = ["resume.sidpanic.io"]

    default_cache_behavior {
        allowed_methods = ["GET", "HEAD"]
        cache_policy_id = aws_cloudfront_cache_policy.cf_origin_cache_policy_allowcookies.id
        cached_methods  = ["GET", "HEAD"]
        compress        = "true"
        default_ttl     = "0"

        grpc_config {
        enabled = "false"
        }

        max_ttl                    = "0"
        min_ttl                    = "0"
        origin_request_policy_id   = aws_cloudfront_origin_request_policy.cf_origin_request_policy_allowcookies.id
        response_headers_policy_id = aws_cloudfront_response_headers_policy.cf_response_header_policy_allowcors.id
        smooth_streaming           = "false"
        target_origin_id           = var.s3_origin
        viewer_protocol_policy     = "redirect-to-https"
    }

    default_root_object = "index.html"
    enabled             = "true"
    http_version        = "http2and3"
    is_ipv6_enabled     = "false"

    ordered_cache_behavior {
        allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
        cache_policy_id = aws_cloudfront_cache_policy.cf_origin_cache_policy_allowcookies.id
        cached_methods  = ["GET", "HEAD", "OPTIONS"]
        compress        = "true"
        default_ttl     = "0"

        grpc_config {
        enabled = "false"
        }

        max_ttl                    = "0"
        min_ttl                    = "0"
        origin_request_policy_id   = aws_cloudfront_origin_request_policy.cf_origin_request_policy_allowcookies.id
        path_pattern               = "/*"
        response_headers_policy_id = aws_cloudfront_response_headers_policy.cf_response_header_policy_allowcors.id
        smooth_streaming           = "false"
        target_origin_id           = var.s3_origin
        viewer_protocol_policy     = "redirect-to-https"
    }

    origin {
        connection_attempts      = "3"
        connection_timeout       = "10"
        domain_name              = var.s3_domain_name
        origin_access_control_id = aws_cloudfront_origin_access_control.origins3resume.id
        origin_id                = var.s3_origin
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
        acm_certificate_arn            = var.cloudfront_cert_arn
        cloudfront_default_certificate = "false"
        minimum_protocol_version       = "TLSv1.2_2021"
        ssl_support_method             = "sni-only"
    }
}
