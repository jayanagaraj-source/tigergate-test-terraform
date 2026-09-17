terraform {
  required_version = ">= 1.4.0"
}

# State-only fixture: no cloud provider credentials are needed.
resource "terraform_data" "application" {
  input = {
    name        = var.application_name
    environment = var.environment
    owner       = var.owner
  }
}
