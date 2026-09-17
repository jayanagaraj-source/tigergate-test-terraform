# Insecure IAM: wildcard admin policy.
resource "aws_iam_policy" "admin" {
  name = "wildcard-admin"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "*"
      Resource = "*"
    }]
  })
}

resource "aws_iam_account_password_policy" "weak" {
  minimum_password_length      = 6
  require_symbols              = false
  require_numbers              = false
  require_uppercase_characters = false
}
