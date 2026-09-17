variable "application_name" {
  description = "Name of the application represented by this Terraform fixture."
  type        = string
  default     = "tigergate-test-terraform"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "test"
}

variable "owner" {
  description = "Team responsible for the application."
  type        = string
  default     = "platform"
}
