# API Reference

This is the launch-scope reference for `upload + publish`.

OpenAPI source of truth: `openapi/v1.yaml`

## Endpoint Matrix

| Method | Path | operationId | Idempotency-Key | Scope (logical) |
|---|---|---|---|---|
| `POST` | `/v1/uploads/presign` | `createUploadPresign` | no | `uploads:write` |
| `POST` | `/v1/uploads/complete` | `completeUpload` | yes | `uploads:write` |
| `GET` | `/v1/uploads/{id}` | `getUploadStatus` | no | `uploads:read` |
| `POST` | `/v1/creator/products` | `createCreatorProductDraft` | yes | `products:write` |
| `PATCH` | `/v1/creator/products/{id}` | `updateCreatorProductDraft` | yes | `products:write` |
| `POST` | `/v1/creator/products/{id}/publish` | `publishCreatorProduct` | yes | `products:write` |

## Request Header Contract

1. `Authorization: Bearer <api_key>`
2. `X-Request-Id` (optional but recommended)
3. `Idempotency-Key` for critical mutations

## Related Guides

1. `docs/getting-started.md`
2. `docs/upload-flow.md`
3. `docs/publish-flow.md`
4. `docs/errors-and-rate-limits.md`

## Runnable Example

```bash
curl -X GET "https://api.voxelshelf.com/api/v1/uploads/upl_123" \
  -H "Authorization: Bearer ${VOXELSHELF_API_KEY}" \
  -H "X-Request-Id: req_reference_demo_001"
```
