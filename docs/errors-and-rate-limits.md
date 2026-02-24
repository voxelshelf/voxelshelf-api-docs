# Errors and Rate Limits

## Error Envelope

All API errors use the same structure:

```json
{
  "error": {
    "code": "invalid_payload",
    "message": "Payload validation failed.",
    "details": [
      { "field": "title", "reason": "required" }
    ],
    "requestId": "req_123",
    "retryable": false
  }
}
```

## Common Error Codes

1. `unauthorized` - missing or invalid API key.
2. `forbidden` - scope or plan restriction.
3. `invalid_payload` - validation failure.
4. `quota_exceeded` - monthly usage or storage quota reached.
5. `rate_limited` - request-per-minute limit exceeded.
6. `not_found` - resource does not exist.
7. `conflict` - duplicate or invalid state transition.

## Rate Limit Headers

The API returns:

1. `RateLimit-Limit`
2. `RateLimit-Remaining`
3. `RateLimit-Reset`

For `429`, the response may include `retryAfterSeconds` in error details.

## Retry Strategy

1. Retry only when `retryable=true`.
2. Use exponential backoff for `429` and transient `5xx`.
3. Do not retry validation errors without changing the payload.

## Runnable Example

```bash
curl -X GET "https://api.voxelshelf.com/api/v1/uploads/upl_123" \
  -H "Authorization: Bearer ${VOXELSHELF_API_KEY}" \
  -H "X-Request-Id: req_errors_demo_001"
```
