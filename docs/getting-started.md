# Getting Started

This guide gets you from API key to published product in under 10 minutes.

## Prerequisites

1. A Voxel Shelf account with API access.
2. A valid API key.
3. A `.zip` file to upload.
4. A tool to run HTTP requests (`curl`, Node, or Python).

## Base URL

Use:

```text
https://api.voxelshelf.com/api
```

All paths in this documentation are relative to that base URL.

## Authentication

Send your key as:

```http
Authorization: Bearer <api_key>
```

See `docs/authentication.md` for details.

## Fast Path

1. Request an upload URL: `POST /v1/uploads/presign`
2. Upload file bytes directly to storage (`PUT` on signed URL)
3. Mark upload as ready: `POST /v1/uploads/complete`
4. Create a draft product: `POST /v1/creator/products`
5. Publish the product: `POST /v1/creator/products/{id}/publish`

## Runnable Examples

- cURL:
  - `examples/curl/upload-presign.sh`
  - `examples/curl/upload-complete.sh`
  - `examples/curl/product-create.sh`
  - `examples/curl/product-publish.sh`
- Node:
  - `examples/node/upload-and-publish.mjs`
- Python:
  - `examples/python/upload_and_publish.py`

## Next Steps

1. Read `docs/upload-flow.md` for detailed upload behavior.
2. Read `docs/publish-flow.md` for draft and publish constraints.
3. Check `docs/errors-and-rate-limits.md` for failure handling.
