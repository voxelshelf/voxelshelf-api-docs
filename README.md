# Voxel Shelf API Docs

Public documentation for the Voxel Shelf Creator API.

## Status

- Version: `v1`
- Scope: `upload + publish`
- Canonical OpenAPI: `openapi/v1.yaml`

## Quick Links

- Getting started: `docs/getting-started.md`
- Upload flow: `docs/upload-flow.md`
- Publish flow: `docs/publish-flow.md`
- API reference: `docs/api-reference.md`
- OpenAPI contract: `openapi/v1.yaml`
- Changelog: `CHANGELOG.md`

## Available Endpoints (v1)

1. `POST /v1/uploads/presign`
2. `POST /v1/uploads/complete`
3. `GET /v1/uploads/{id}`
4. `POST /v1/creator/products`
5. `PATCH /v1/creator/products/{id}`
6. `POST /v1/creator/products/{id}/publish`

## Planned (Not Available Yet)

- OAuth PKCE applications for third-party clients.
- Bulk import jobs.
- Bundles API.

Use the current docs and OpenAPI file as the source of truth for what is live in v1.
