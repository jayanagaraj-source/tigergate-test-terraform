# Deliberately insecure test fixtures

This repository is for validating SCA, SAST, secret, and IaC scanners. It deliberately contains outdated dependencies, unsafe code patterns, fake hard-coded credentials, and insecure infrastructure settings. Do not deploy or reuse these patterns.

## Multi-scanner fixtures

See [`fixtures/`](fixtures/) for SCA, SAST, secret, IaC, and SBOM test fixtures with a
detection matrix and a runnable `fixtures/scan.sh` (trivy + grype + syft).
