#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${BASE_URL:-https://api.voxelshelf.com/api}"
API_KEY="${VOXELSHELF_API_KEY:-}"
ASSET_STORAGE_KEY="${ASSET_STORAGE_KEY:-uploads/demo/model.zip}"

if [[ -z "${API_KEY}" ]]; then
  echo "Missing VOXELSHELF_API_KEY"
  exit 1
fi

curl -sS -X POST "${BASE_URL}/v1/creator/products" \
  -H "Authorization: Bearer ${API_KEY}" \
  -H "Content-Type: application/json" \
  -H "X-Request-Id: req_product_create_demo_001" \
  -H "Idempotency-Key: idem-product-create-001" \
  -d "{
    \"title\": \"Demo Upload API Model\",
    \"description\": \"Model created via public API\",
    \"category\": \"Home & Decor\",
    \"subcategory\": \"Decor & Lighting\",
    \"printMaterials\": [\"PLA\"],
    \"supports\": \"Optional\",
    \"difficulty\": \"Easy\",
    \"isPresupported\": false,
    \"license\": \"Personal\",
    \"price\": 10,
    \"images\": [
      { \"url\": \"https://images.voxelshelf.com/demo-1.jpg\", \"alt\": \"Preview\" }
    ],
    \"files\": [
      {
        \"storageKey\": \"${ASSET_STORAGE_KEY}\",
        \"filename\": \"model.zip\",
        \"size\": 1234567,
        \"mime\": \"application/zip\",
        \"kind\": \"Archive\"
      }
    ]
  }"
