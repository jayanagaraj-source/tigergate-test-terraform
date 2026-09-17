# Deliberately insecure Terraform test fixtures

This repository is an **all-Terraform** test bed for validating IaC (and secret)
scanners. Every `.tf` file below deliberately contains insecure infrastructure
settings, an outdated provider, or fake hard-coded credentials. Do not apply or
reuse any of it.

## Layout (all Terraform)

| File | Focus | Example issues |
|------|-------|----------------|
| `s3.tf`          | S3            | public ACL, public-access-block disabled, unencrypted |
| `ec2.tf`         | EC2           | IMDSv1 allowed, unencrypted root volume, public IP, secret in user_data |
| `iam.tf`         | IAM           | `Action:"*"` admin policy, weak password policy |
| `networking.tf`  | VPC / SG      | SSH+RDP open to 0.0.0.0/0, unrestricted egress |
| `logging.tf`     | CloudTrail    | log validation off, single-region |
| `kms.tf`         | KMS           | key rotation disabled |
| `database.tf`    | DynamoDB/Redshift | no encryption, no PITR, public, hard-coded password |
| `containers.tf`  | ECR / EKS     | mutable tags, scan-on-push off, public EKS endpoint 0.0.0.0/0 |
| `messaging.tf`   | SNS / SQS     | unencrypted topic and queue |
| `insecure.tf`    | S3            | public-access-block disabled |
| `modules/insecure_aws.tf` | SG/RDS/S3/EBS | open SG, public+unencrypted RDS/S3/EBS |
| `secrets.tf`     | secrets       | fake hard-coded AWS keys (secret-scanner bait) |
| `versions.tf`    | SCA           | pinned `hashicorp/aws 3.0.0` (deliberately outdated) |

`main.tf`, `variables.tf`, `outputs.tf` are intentionally benign (no findings expected).

## Verified detection (trivy 0.68.1)

- `terraform validate` passes (valid HCL).
- **79 IaC misconfig failures** across 11 `.tf` files (5 CRITICAL / 36 HIGH / 22 MEDIUM / 16 LOW).

```sh
terraform init -backend=false && terraform validate
trivy config .            # IaC misconfigurations
trivy fs --scanners secret .   # hard-coded credentials
```

## Go SAST fixture

`sast-go/vulnerable.go` is a compilable Go module with deliberate SAST issues for
source-code scanners (gosec / semgrep / TigerGate SAST):

| Issue | gosec rule | CWE |
|-------|-----------|-----|
| Hard-coded credentials      | G101      | CWE-798 |
| SQL injection (fmt.Sprintf) | G201      | CWE-89  |
| OS command injection        | G204      | CWE-78  |
| Path traversal              | G304      | CWE-22  |
| SSRF (variable URL)         | G107      | CWE-918 |
| Weak hash (MD5)             | G401/G501 | CWE-327 |
| TLS InsecureSkipVerify      | G402      | CWE-295 |
| Insecure randomness         | G404      | CWE-338 |

Verified: `go build ./...` passes; gosec reports 8 issues, semgrep reports 7.
