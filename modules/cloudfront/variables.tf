variable "cf_origin_request_policy_id" {
  description = "Origin request policy for Cloudfront"
  type        = string
  default     = "5f6280ba-27b8-48a6-bc2c-d2237218c557"
}

variable "cf_response_headers_policy_id" {
  description = "Response headers policy for Cloudfront"
  type        = string
  default     = "ab14d56b-552c-4128-8fac-21fc0a550fb4"
}

variable "s3_origin" {
  description = "Origin for S3 bucket"
  type        = string
  default     = "resumeS3origin"
}

variable "s3_domain_name" {
  type        = string
  description = "S3 bucket REST endpoint, e.g. my-bucket.s3.ap-southeast-1.amazonaws.com"
}

variable "cloudfront_cert_arn" {
  type        = string
  description = "Cloudfront Certificate ARN, output from acm moduke"
}