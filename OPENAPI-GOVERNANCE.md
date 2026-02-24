# OpenAPI Governance

Status: Active  
Owner: API Platform  
Last updated: 2026-02-24

## 1) Source of Truth

1. Canonical contract file in private source repo: `openapi/v1.yaml`.
2. Canonical contract file in public docs repo: `openapi/v1.yaml`.
3. Public documentation scope for v1 is `upload + publish` only.

## 2) OpenAPI-First Rule

No public endpoint change is considered complete unless:

1. `openapi/v1.yaml` is updated.
2. `docs/api/docs/api-reference.md` is aligned with operation IDs.
3. At least one runnable example exists for the affected flow.

## 3) Contract Standards

1. OpenAPI version: `3.1.0`.
2. Operation IDs are required and stable.
3. Error envelope must remain consistent:

```json
{
  "error": {
    "code": "string",
    "message": "string",
    "details": [],
    "requestId": "string",
    "retryable": false
  }
}
```

4. Critical mutation endpoints must require `Idempotency-Key`.

## 4) Breaking Change Policy

Changes are breaking when they remove or change endpoint behavior in a non-compatible way (removed path, removed field, incompatible type, stricter required field without fallback).

For breaking changes:

1. Create a dedicated design note or ADR.
2. Publish migration notes.
3. Version accordingly.

## 5) Scope Policy (v1)

Documented and supported now:

1. `/v1/uploads/presign`
2. `/v1/uploads/complete`
3. `/v1/uploads/{id}`
4. `/v1/creator/products`
5. `/v1/creator/products/{id}`
6. `/v1/creator/products/{id}/publish`

Future items must be labeled clearly as:

`Planned (not available yet)`

## 6) Quality Gates

The docs quality workflow must verify:

1. required public docs files exist;
2. scope endpoint coverage matches OpenAPI;
3. operation IDs are represented in API reference;
4. docs are English-only (public paths);
5. examples pass static checks.

## 7) Public Sync Governance

Sync workflow in private repo: `.github/workflows/api-docs-sync.yml`

Required secrets:

1. `API_DOCS_SYNC_TOKEN`
2. `API_DOCS_TARGET_REPO` (for example: `voxelshelf/voxelshelf-api-docs`)

Published content scope from private repo:

1. `docs/api/**` -> public repo root
2. `openapi/v1.yaml` -> public `openapi/v1.yaml`

No runtime source code or private infrastructure data is published.

## 8) Operational Runbook (Public Docs)

### 8.1 Decision log (active)

1. `.github/**` is intentionally excluded from public sync payload.
2. Public-repo workflow files are managed directly in `voxelshelf/voxelshelf-api-docs`.
3. This decision reduces token scope pressure and avoids workflow-permission failures during mirror push.

### 8.2 Secret ownership and rotation registry

Maintain this registry in the source repo settings + team ops notes:

1. Secret: `API_DOCS_SYNC_TOKEN`
   - Owner: `voxelshelf` org (designated maintainer)
   - Scope: `Contents` read/write (target repo only)
   - Expiration: must be tracked and reviewed monthly
   - Rotation policy: rotate immediately on exposure, then at fixed cadence
2. Secret: `API_DOCS_TARGET_REPO`
   - Value pattern: `<org>/<repo>`
   - Current target: `voxelshelf/voxelshelf-api-docs`

### 8.3 Recovery procedure (drift or failed auto-sync)

1. Verify latest source SHA in `main`.
2. Trigger `API Docs Sync` manually on `main`.
3. Confirm workflow is green (no 403).
4. Confirm public mirror commit exists with message:
   - `sync(api-docs): <sha_source>`
5. If still failing, validate secrets and target repo write access before rerun.

### 8.4 Quality gate enforcement

1. Keep `API Docs Quality` enabled on `pull_request` for changes in:
   - `docs/api/**`
   - `openapi/v1.yaml`
2. Require this check in branch protection/ruleset where admin access is available.
