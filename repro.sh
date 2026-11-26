#!/usr/bin/env bash
# Scans both examples with Trivy 0.76.2 and prints the GCP-0061 result for each.
# Needs Docker. Usage: ./repro.sh
set -euo pipefail
cd "$(dirname "$0")"
for dir in dns-endpoint-only with-empty-block; do
  echo "== $dir"
  docker run --rm -v "$PWD/$dir:/src:ro" aquasec/trivy@sha256:8f6bb947dbc528902e11f2f5be52f7b519f6a39d5d148f41166f2040499768fb config --quiet --format table /src \
    | grep -E "^Failures|GCP-0061"
done
