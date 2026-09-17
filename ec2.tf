# Insecure EC2: IMDSv1 allowed, unencrypted root volume, public IP.
resource "aws_instance" "web" {
  ami                         = "ami-0abcd1234efgh5678"
  instance_type               = "t2.micro"
  associate_public_ip_address = true

  metadata_options {
    http_tokens = "optional" # IMDSv1 permitted (AVD-AWS-0028)
  }

  root_block_device {
    encrypted = false
  }

  user_data = <<-USERDATA
    #!/bin/bash
    export DB_PASSWORD=SuperSecret123!
  USERDATA
}
