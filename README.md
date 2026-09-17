# tigergate-test-terraform

A standalone Terraform test fixture. It uses Terraform's built-in `terraform_data`
resource, so `terraform init` and `terraform validate` do not require cloud
credentials.

```sh
terraform init -backend=false
terraform validate
terraform plan
```

Copy `terraform.tfvars.example` to `terraform.tfvars` to customize the inputs.
