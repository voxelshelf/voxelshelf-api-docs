#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${BASE_URL:-https://api.voxelshelf.com/api}"
API_KEY="${VOXELSHELF_API_KEY:-}"
UPLOAD_ID="${UPLOAD_ID:-}"

if [[ -z "${API_KEY}" ]]; then
  echo "Missing VOXELSHELF_API_KEY"
  exit 1
fi

if [[ -z "${UPLOAD_ID}" ]]; then
  echo "Missing UPLOAD_ID"
  exit 1
fi

curl -sS -X POST "${BASE_URL}/v1/uploads/complete" \
  -H "Authorization: Bearer ${API_KEY}" \
  -H "Content-Type: application/json" \
  -H "X-Request-Id: req_upload_complete_demo_001" \
  -H "Idempotency-Key: idem-upload-complete-001" \
  -d "{
    \"uploadId\": \"${UPLOAD_ID}\"
  }"
