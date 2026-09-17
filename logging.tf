# Insecure logging: unencrypted CloudTrail, no log validation, no VPC flow logs.
resource "aws_cloudtrail" "main" {
  name                          = "insecure-trail"
  s3_bucket_name                = "tigergate-trail-bucket"
  enable_log_file_validation    = false
  include_global_service_events = false
  is_multi_region_trail         = false
}
