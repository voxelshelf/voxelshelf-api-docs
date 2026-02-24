# Publish Flow

After an upload is `READY`, use it to create or update a product draft, then publish.

## 1) Create Draft

Endpoint:

```text
POST /v1/creator/products
```

Header:

```text
Idempotency-Key: <stable-key>
```

Runnable example:

```bash
bash examples/curl/product-create.sh
```

## 2) Update Draft

Endpoint:

```text
PATCH /v1/creator/products/{id}
```

Header:

```text
Idempotency-Key: <stable-key>
```

Use this when you need to patch metadata, images, or files before publish.

## 3) Publish

Endpoint:

```text
POST /v1/creator/products/{id}/publish
```

Header:

```text
Idempotency-Key: <stable-key>
```

Runnable example:

```bash
bash examples/curl/product-publish.sh
```

## Publish Constraints (v1)

1. Your key must have product write scope.
2. Your plan must allow publish in production.
3. Invalid draft state returns a structured API error.
