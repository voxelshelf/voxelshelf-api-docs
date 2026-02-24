# Authentication

## API Key (Current v1)

Use:

```http
Authorization: Bearer <api_key>
```

Recommended header set for mutable requests:

```http
Authorization: Bearer <api_key>
Content-Type: application/json
X-Request-Id: <client-request-id>
Idempotency-Key: <stable-key-for-this-operation>
```

Example:

```bash
curl -X GET "https://api.voxelshelf.com/api/v1/uploads/upl_123" \
  -H "Authorization: Bearer ${VOXELSHELF_API_KEY}"
```

## Key Safety

1. Never embed production API keys in frontend code.
2. Store keys in secure secret managers.
3. Rotate keys immediately after suspected exposure.

## Planned (Not Available Yet)

- OAuth Authorization Code + PKCE for user-installed integrations.

When this becomes available, it will be documented as a separate auth mode.
