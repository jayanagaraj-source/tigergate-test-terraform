# Insecure KMS: key rotation disabled.
resource "aws_kms_key" "main" {
  description             = "insecure key"
  enable_key_rotation     = false
  deletion_window_in_days = 7
}
