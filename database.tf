# Insecure managed databases: unencrypted, public, no PITR, hard-coded password.
resource "aws_dynamodb_table" "sessions" {
  name         = "sessions"
  hash_key     = "id"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "id"
    type = "S"
  }
  point_in_time_recovery {
    enabled = false
  }
  server_side_encryption {
    enabled = false
  }
}

resource "aws_redshift_cluster" "warehouse" {
  cluster_identifier  = "insecure-warehouse"
  database_name       = "analytics"
  master_username     = "admin"
  master_password     = "Redshift-Passw0rd!"
  node_type           = "dc2.large"
  publicly_accessible = true
  encrypted           = false
}
