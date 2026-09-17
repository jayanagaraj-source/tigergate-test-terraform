# Deliberately insecure S3 config for IaC scanner testing. Do not apply.
resource "aws_s3_bucket" "data" {
  bucket = "tigergate-data-insecure"
  acl    = "public-read" # public ACL (provider-3.x compatible)
}

resource "aws_s3_bucket_public_access_block" "data" {
  bucket                  = aws_s3_bucket.data.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
