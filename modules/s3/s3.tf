locals {
  mime_types = {
    html = "text/html"
    css  = "text/css"
    js   = "application/javascript"
    json = "application/json"
    png  = "image/png"
    jpg  = "image/jpeg"
    jpeg = "image/jpeg"
    svg  = "image/svg+xml"
    txt  = "text/plain"
  }
}

resource "aws_s3_bucket" "resume-bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = "${var.bucket_name}-nametag"
  }
}

# Unblock public access
resource "aws_s3_bucket_public_access_block" "resume-bucket" {
  bucket = aws_s3_bucket.resume-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Place all items found in ./files in s3 bucket
resource "aws_s3_object" "all_files" {
  for_each = fileset(var.local_folder, "**")

  bucket = aws_s3_bucket.resume-bucket.id
  key    = each.value
  source = "${var.local_folder}/${each.value}"
  etag   = filemd5("${var.local_folder}/${each.value}")

  # Get extension of the file
  content_type = lookup(
    local.mime_types,
    element(split(".", each.value), length(split(".", each.value)) - 1),
    "application/octet-stream" # default fallback
  )

  depends_on = [
    aws_s3_bucket_public_access_block.resume-bucket,
    aws_s3_bucket.resume-bucket
    ]
}