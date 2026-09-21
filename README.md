# tigergate-test-terraform

An **all-Terraform** test fixture for validating IaC / secret / SCA scanners
(e.g. TigerGate, trivy, checkov, tfsec). Every `.tf` file deliberately contains
insecure infrastructure, an outdated provider, or fake credentials.

```sh
terraform init -backend=false
terraform validate          # passes: the HCL is valid
terraform plan              # requires an aws provider region; init/validate do not
```

Scan it:

```sh
trivy config .                  # IaC misconfigurations (79 expected)
trivy fs --scanners secret .    # hard-coded credentials
```

See `SECURITY_FIXTURES.md` for the per-file breakdown of planted issues and the
verified detection counts.
# tigergate-test-terraform
# tigergate-test-terraform
