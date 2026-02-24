import json
import os
import sys

import requests


BASE_URL = os.getenv("BASE_URL", "https://api.voxelshelf.com/api")
API_KEY = os.getenv("VOXELSHELF_API_KEY")
UPLOAD_ID = os.getenv("UPLOAD_ID", "upl_replace_me")
ASSET_STORAGE_KEY = os.getenv("ASSET_STORAGE_KEY", "uploads/demo/model.zip")

if not API_KEY:
    print("Missing VOXELSHELF_API_KEY", file=sys.stderr)
    sys.exit(1)

headers = {
  "Authorization": f"Bearer {API_KEY}",
}

complete_resp = requests.post(
  f"{BASE_URL}/v1/uploads/complete",
  headers={
    **headers,
    "Content-Type": "application/json",
    "X-Request-Id": "req_py_upload_complete_001",
    "Idempotency-Key": "idem-py-upload-complete-001",
  },
  json={"uploadId": UPLOAD_ID},
  timeout=30,
)
complete_resp.raise_for_status()

create_payload = {
  "title": "Python Example Product",
  "description": "Created from Python API example.",
  "category": "Home & Decor",
  "subcategory": "Decor & Lighting",
  "printMaterials": ["PLA"],
  "supports": "Optional",
  "difficulty": "Easy",
  "isPresupported": False,
  "license": "Personal",
  "price": 9,
  "images": [{"url": "https://images.voxelshelf.com/demo-python.jpg", "alt": "Python demo"}],
  "files": [
    {
      "storageKey": ASSET_STORAGE_KEY,
      "filename": "model.zip",
      "size": 1234567,
      "mime": "application/zip",
      "kind": "Archive",
    }
  ],
}

create_resp = requests.post(
  f"{BASE_URL}/v1/creator/products",
  headers={
    **headers,
    "Content-Type": "application/json",
    "X-Request-Id": "req_py_product_create_001",
    "Idempotency-Key": "idem-py-product-create-001",
  },
  data=json.dumps(create_payload),
  timeout=30,
)
create_resp.raise_for_status()
draft = create_resp.json()
product_id = draft.get("id")
if not product_id:
  raise RuntimeError("create product response did not include id")

publish_resp = requests.post(
  f"{BASE_URL}/v1/creator/products/{product_id}/publish",
  headers={
    **headers,
    "X-Request-Id": "req_py_product_publish_001",
    "Idempotency-Key": "idem-py-product-publish-001",
  },
  timeout=30,
)
publish_resp.raise_for_status()
print(publish_resp.json())
