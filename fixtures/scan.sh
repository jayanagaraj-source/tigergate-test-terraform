#!/usr/bin/env bash
# Run the local scanners against the fixtures and print a summary.
# Requires: trivy, grype, syft (swap in TigerGate as needed).
set -uo pipefail
cd "$(dirname "$0")"
OUT="${1:-./scan-output}"
mkdir -p "$OUT"

echo "== SBOM (syft) =="
syft scan dir:sca -o cyclonedx-json="$OUT/sbom.cdx.json" -o spdx-json="$OUT/sbom.spdx.json" -q
echo "  packages: $(jq '.components|length' "$OUT/sbom.cdx.json")"

echo "== SCA + Secrets + IaC (trivy) =="
trivy fs --scanners vuln,secret,misconfig -f json -o "$OUT/trivy.json" -q .
echo "  vulnerabilities: $(jq '[.Results[]?.Vulnerabilities[]?]|length' "$OUT/trivy.json")"
echo "  secret hits:     $(jq '[.Results[]?.Secrets[]?]|length' "$OUT/trivy.json")"
echo "  misconfig fails: $(jq '[.Results[]?.Misconfigurations[]?|select(.Status=="FAIL")]|length' "$OUT/trivy.json")"

echo "== SCA (grype, from SBOM) =="
grype "sbom:$OUT/sbom.cdx.json" -o json --file "$OUT/grype.json" -q
echo "  matches: $(jq '.matches|length' "$OUT/grype.json")"

echo "Done. JSON reports in $OUT/"
