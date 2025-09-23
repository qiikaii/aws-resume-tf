variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "resume-prod-ap-southeast-1-s3bucket"
}

variable "local_folder" {
  type    = string
  default = "files"
}