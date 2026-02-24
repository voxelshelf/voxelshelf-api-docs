#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${BASE_URL:-https://api.voxelshelf.com/api}"
API_KEY="${VOXELSHELF_API_KEY:-}"

if [[ -z "${API_KEY}" ]]; then
  echo "Missing VOXELSHELF_API_KEY"
  exit 1
fi

curl -sS -X POST "${BASE_URL}/v1/uploads/presign" \
  -H "Authorization: Bearer ${API_KEY}" \
  -H "Content-Type: application/json" \
  -H "X-Request-Id: req_upload_presign_demo_001" \
  -d '{
    "filename": "model.zip",
    "contentType": "application/zip",
    "size": 1234567,
    "kind": "file"
  }'
