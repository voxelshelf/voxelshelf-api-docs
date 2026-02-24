# Upload Flow

The upload flow is always:

1. `presign`
2. direct upload to signed storage URL
3. `complete`

## 1) Request Presigned URL

Endpoint:

```text
POST /v1/uploads/presign
```

Minimal request payload:

```json
{
  "filename": "model.zip",
  "contentType": "application/zip",
  "size": 1234567,
  "kind": "file"
}
```

Runnable example:

```bash
bash examples/curl/upload-presign.sh
```

## 2) Upload Bytes to Signed URL

The API returns `uploadUrl` and `uploadId`.

Upload bytes with HTTP `PUT` to the returned signed URL. This step does not go through the Voxel Shelf API runtime, which keeps operational cost predictable.

## 3) Complete Upload

Endpoint:

```text
POST /v1/uploads/complete
```

Header:

```text
Idempotency-Key: <stable-key>
```

Minimal request payload:

```json
{
  "uploadId": "upl_123"
}
```

Runnable example:

```bash
bash examples/curl/upload-complete.sh
```

## 4) Check Upload Status

Endpoint:

```text
GET /v1/uploads/{id}
```

Final status for successful upload is `READY`.

## Operational Rules

1. Maximum file size for v1: 1 GiB.
2. Pending upload TTL: 24 hours.
3. Expired or orphaned pending uploads are cleaned up automatically.
