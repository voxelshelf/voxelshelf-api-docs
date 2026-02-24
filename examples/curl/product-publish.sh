#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${BASE_URL:-https://api.voxelshelf.com/api}"
API_KEY="${VOXELSHELF_API_KEY:-}"
PRODUCT_ID="${PRODUCT_ID:-}"

if [[ -z "${API_KEY}" ]]; then
  echo "Missing VOXELSHELF_API_KEY"
  exit 1
fi

if [[ -z "${PRODUCT_ID}" ]]; then
  echo "Missing PRODUCT_ID"
  exit 1
fi

curl -sS -X POST "${BASE_URL}/v1/creator/products/${PRODUCT_ID}/publish" \
  -H "Authorization: Bearer ${API_KEY}" \
  -H "X-Request-Id: req_product_publish_demo_001" \
  -H "Idempotency-Key: idem-product-publish-001"
