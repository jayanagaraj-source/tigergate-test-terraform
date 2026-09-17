# Deliberately insecure Terraform for IaC scanner testing. Do not apply.
provider "aws" {
  region = "us-east-1"
}

# Security group open to the world on SSH
resource "aws_security_group" "wide_open" {
  name = "wide-open"
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Unencrypted S3 bucket, no logging
resource "aws_s3_bucket" "unencrypted" {
  bucket = "tigergate-unencrypted-fixture"
}

# RDS instance publicly accessible, no encryption, hard-coded password
resource "aws_db_instance" "public_db" {
  allocated_storage   = 20
  engine              = "mysql"
  instance_class      = "db.t2.micro"
  username            = "admin"
  password            = "Password123!"
  publicly_accessible = true
  storage_encrypted   = false
  skip_final_snapshot = true
}

# Unencrypted, non-versioned EBS volume
resource "aws_ebs_volume" "data" {
  availability_zone = "us-east-1a"
  size              = 40
  encrypted         = false
}
