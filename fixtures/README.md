# TigerGate scanner test fixtures

Deliberately vulnerable fixtures for validating **SCA, SAST, secret, IaC, and SBOM**
detection. Everything here is a non-functional test artifact — do not deploy, run,
or reuse any of it.

```
fixtures/
├── sca/        SCA — dependency manifests pinned to known-CVE versions
│   ├── npm/         package.json + package-lock.json  (lodash, minimist, axios, jsonwebtoken)
│   ├── python/      requirements.txt                  (Flask, Django, PyYAML, requests, urllib3, ...)
│   ├── java/        pom.xml                            (log4j-core, commons-collections, jackson, spring)
│   └── go/          go.mod                             (jwt-go, gin, yaml.v2)
├── sast/       SAST — insecure source (SQLi, cmd injection, eval, deserialization, weak crypto, SSRF, XSS)
│   ├── python/vulnerable.py
│   ├── javascript/vulnerable.js
│   └── java/Vulnerable.java
├── secrets/    Secrets — fake tokens + a freshly generated throwaway RSA key
├── iac/        IaC misconfig — Terraform, Dockerfile, Kubernetes
├── sbom/       Generated SBOMs (CycloneDX + SPDX)
└── scan.sh     Runs trivy + grype + syft and prints a summary
```

Run the reference scan (swap in TigerGate as needed):

```sh
./fixtures/scan.sh
```

## Signature vulnerabilities (deterministic, known-CVE)

| Category | Fixture | Planted issue | Reference |
|----------|---------|---------------|-----------|
| SCA  | java/pom.xml            | log4j-core 2.14.1 (Log4Shell)      | CVE-2021-44228 |
| SCA  | java/pom.xml            | commons-collections 3.2.1 deser.   | CVE-2015-6420 |
| SCA  | go/go.mod               | jwt-go 3.2.0 auth bypass           | CVE-2020-26160 |
| SCA  | npm/package-lock.json   | lodash 4.17.11 prototype pollution | CVE-2019-10744 |
| SCA  | npm/package-lock.json   | minimist 1.2.0 prototype pollution | CVE-2020-7598 |
| SCA  | python/requirements.txt | PyYAML 5.1 arbitrary code exec     | CVE-2020-1747 |
| SCA  | python/requirements.txt | urllib3 1.24.1 CRLF                 | CVE-2019-11324 |
| Secret | secrets/credentials.env | non-example AWS access key id    | aws-access-key-id |
| Secret | secrets/credentials.env | GitHub PAT / Stripe / Slack      | github-pat, stripe, slack |
| IaC  | iac/terraform           | SG open 0.0.0.0/0, public+unencrypted RDS/S3/EBS | AVD-AWS-0107/0080/0180/0088 |
| IaC  | iac/docker/Dockerfile   | root user, secret in ENV, port 22  | DS002, DS031, DS004 |
| IaC  | iac/kubernetes          | privileged, hostNetwork, hostPID   | KSV017, KSV009, KSV010 |

## Verified detection (local reference scanners)

Last run with **trivy 0.68.1**, **grype 0.118.0**, **syft 1.51.1**:

| Scan type | Tool | Result |
|-----------|------|--------|
| SBOM      | syft  | 21 packages across 4 ecosystems |
| SCA       | trivy | 183 vulns (23 CRITICAL / 86 HIGH); all 7 signature CVEs hit |
| SCA       | grype | 179 matches (independent confirmation) |
| Secrets   | trivy | 6 rule hits (aws, github, stripe, slack x2, npm) |
| IaC       | trivy | 49 misconfig failures across Terraform / Docker / Kubernetes |

## Known detection gaps (scanner-dependent — by design, not fixture bugs)

- **AWS example key `AKIAIOSFODNN7EXAMPLE` is intentionally NOT flagged** by trivy
  (and most scanners allowlist vendor doc examples). `secrets/credentials.env` therefore
  also carries a non-example fake key so `aws-access-key-id` fires. Keep this in mind when
  judging TigerGate output.
- **Private key `secrets/test_id_rsa` is not caught by trivy's default secret ruleset**
  (trivy's built-ins cover provider tokens, not asymmetric private keys). gitleaks-style
  rulesets — and presumably TigerGate — do detect `BEGIN RSA PRIVATE KEY`. The fixture is a
  real, freshly generated, unused 2048-bit key.
- **SAST** (source-level SQLi / command injection / eval / deserialization) is **not**
  verified by trivy/grype/syft — those do SCA/secret/IaC, not taint analysis. Verify the
  `sast/` fixtures with TigerGate's SAST engine (or semgrep) directly.
