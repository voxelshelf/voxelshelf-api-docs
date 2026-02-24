# Creator API v1 (Demand Elegance)

Status: Proposed  
Owner: Product + API Platform  
Last updated: 2026-02-24

## 1) Objetivo

Definir a API publica de creators com foco em:

1. fluxo simples e barato por padrao (item a item);
2. escala opcional via import job assincrono;
3. gestao completa de produtos e bundles;
4. baixo custo operacional para time de 1 pessoa;
5. DX forte para integracoes externas.

## 2) Principios (Demand Elegance)

1. Simples por padrao: todo creator deve conseguir publicar sem batch.
2. Escala sob demanda: import job existe, mas nunca e obrigatorio.
3. Contrato estavel: OpenAPI-first, idempotencia e erros padronizados.
4. Custo previsivel: quotas, rate limits, TTL de uploads e cleanup automatico.
5. Seguranca pragmatica: API keys com scopes + OAuth PKCE, sem grants extras no v1.

## 3) Escopo v1

### In scope

1. Auth: API keys + OAuth 2.0 Authorization Code + PKCE.
2. Uploads: presign + complete + status.
3. Creator products: CRUD + publish/hide.
4. Creator bundles: CRUD + publish/hide + reorder items.
5. Import jobs: criacao, status, itens, cancelamento.
6. Governanca: rate limit headers, idempotency key, envelope unico de erro.

### Out of scope (v1)

1. Checkout e fluxos buyer.
2. Download/entitlement publico.
3. Webhooks publicos no dia 1 (pode entrar no v1.1).
4. OAuth client credentials (avaliar apos v1 GA).

## 4) Base URL e versionamento

1. Namespace oficial: `/v1`.
2. Todas as rotas publicas devem existir sob `/v1/*`.
3. Politica de versao: SemVer no contrato OpenAPI.
4. Mudanca breaking: apenas em nova major (`/v2`) ou com janela formal de deprecacao.

## 5) Autenticacao e autorizacao

## 5.1 API Keys (server-to-server)

1. Header: `Authorization: Bearer <api_key>`.
2. Chave com prefixo legivel (`vs_live_`, `vs_test_`) e hash server-side.
3. Scopes minimos v1:
   - `uploads:write`
   - `products:read`
   - `products:write`
   - `bundles:read`
   - `bundles:write`
   - `imports:write`
   - `imports:read`
4. Revogacao imediata invalida requisicoes subsequentes.

## 5.2 OAuth 2.0 + PKCE (apps web/mobile)

1. Endpoints:
   - `GET /v1/oauth/authorize`
   - `POST /v1/oauth/token`
   - `POST /v1/oauth/revoke`
2. Grant permitido no v1: Authorization Code + PKCE.
3. Rejeitar requests sem `code_verifier` valido quando fluxo PKCE for exigido.
4. Tokens devem carregar scopes equivalentes aos de API key.

## 6) Convencoes de request/response

1. Headers padrao:
   - `Authorization`
   - `X-Request-Id` (opcional no cliente, ecoado pelo servidor)
   - `Idempotency-Key` (obrigatorio em mutacoes criticas)
2. Envelope de erro unico:

```json
{
  "error": {
    "code": "invalid_payload",
    "message": "Payload validation failed.",
    "details": [
      { "field": "title", "reason": "required" }
    ],
    "requestId": "req_01H...",
    "retryable": false
  }
}
```

3. Rate limit headers padrao:
   - `RateLimit-Limit`
   - `RateLimit-Remaining`
   - `RateLimit-Reset`
4. `429` deve incluir `retryAfterSeconds` no corpo.

## 7) Rate limits e planos

## 7.1 Sandbox free

1. `60 req/min`.
2. `5k req/dia`.
3. `1` import job concorrente por creator.
4. Sem overage.

## 7.2 Produção paga

1. Planos mensais por quota (requests/dia, upload bytes, concorrencia de jobs).
2. Overages opcionais apenas em planos que explicitamente habilitarem.
3. Quotas aplicadas por chave e por creator (dupla protecao).

## 8) Fluxos recomendados

## 8.1 Fluxo simples (item a item)

1. `POST /v1/uploads/presign`
2. `PUT` direto no storage usando URL assinada
3. `POST /v1/uploads/complete`
4. `POST /v1/creator/products` (ou `PATCH`)
5. `POST /v1/creator/products/:id/publish` quando pronto

## 8.2 Fluxo de escala (import job)

1. `POST /v1/creator/import-jobs`
2. `GET /v1/creator/import-jobs/:id` (polling de status)
3. `GET /v1/creator/import-jobs/:id/items` (resultado por item)
4. `POST /v1/creator/import-jobs/:id/cancel` quando necessario

## 9) Catalogo de endpoints v1

## 9.1 Auth

1. `GET /v1/oauth/authorize`
2. `POST /v1/oauth/token`
3. `POST /v1/oauth/revoke`

## 9.2 API keys

1. `POST /v1/creator/api-keys`
2. `GET /v1/creator/api-keys`
3. `DELETE /v1/creator/api-keys/:id`

## 9.3 Uploads

1. `POST /v1/uploads/presign`
2. `POST /v1/uploads/complete`
3. `GET /v1/uploads/:id`

## 9.4 Products

1. `GET /v1/creator/products`
2. `POST /v1/creator/products`
3. `GET /v1/creator/products/:id`
4. `PATCH /v1/creator/products/:id`
5. `DELETE /v1/creator/products/:id`
6. `POST /v1/creator/products/:id/publish`
7. `POST /v1/creator/products/:id/hide`

## 9.5 Bundles

1. `GET /v1/creator/bundles`
2. `POST /v1/creator/bundles`
3. `GET /v1/creator/bundles/:id`
4. `PATCH /v1/creator/bundles/:id`
5. `DELETE /v1/creator/bundles/:id`
6. `POST /v1/creator/bundles/:id/publish`
7. `POST /v1/creator/bundles/:id/hide`
8. `PUT /v1/creator/bundles/:id/items`

## 9.6 Import jobs

1. `POST /v1/creator/import-jobs`
2. `GET /v1/creator/import-jobs/:id`
3. `GET /v1/creator/import-jobs/:id/items`
4. `POST /v1/creator/import-jobs/:id/cancel`

## 10) Tipos internos previstos (implementacao futura)

1. `ApiClientApp`: `id`, `creatorId`, `name`, `status`, `createdAt`.
2. `ApiCredential`: `id`, `appId`, `type`, `prefix`, `scopes[]`, `lastUsedAt`, `revokedAt`.
3. `UploadAsset`: `id`, `creatorId`, `storageKey`, `kind`, `size`, `mime`, `checksum`, `status`, `expiresAt`.
4. `ImportJob`: `id`, `creatorId`, `type`, `status`, `source`, `totalItems`, `processedItems`, `successItems`, `failedItems`, `startedAt`, `finishedAt`.
5. `ImportJobItemResult`: `jobId`, `index`, `externalRef`, `status`, `resourceId`, `errorCode`, `errorMessage`.

## 11) Guardrails de custo e operacao

1. Max tamanho por upload (imagem e arquivo).
2. TTL para upload nao finalizado.
3. Cleanup automatico de assets orfaos.
4. Limite de jobs concorrentes por creator.
5. Limite de bytes/dia por creator.
6. Idempotencia obrigatoria em criacao de recursos e transicoes de estado.

## 12) Observabilidade

1. Todo response deve carregar `requestId`.
2. Registrar latencia, status code, scope, creatorId e route key.
3. Alertas minimos:
   - spike de `429`
   - taxa de `5xx` acima de SLO
   - crescimento anormal de uploads orfaos
4. Dashboard operacional por plano (sandbox vs paid).

## 13) Segurança

1. Secrets apenas hashed/encrypted (nunca plaintext em banco).
2. Escopos obrigatorios por endpoint.
3. Rate limit por chave + creator + IP.
4. Rotacao e revogacao de credenciais com efeito imediato.
5. Rejeitar payloads sem validacao estrita.

## 14) Exemplos rapidos

## 14.1 cURL - presign upload

```bash
curl -X POST "https://api.voxelshelf.com/v1/uploads/presign" \
  -H "Authorization: Bearer vs_live_xxx" \
  -H "Content-Type: application/json" \
  -H "X-Request-Id: req_demo_001" \
  -d '{
    "filename": "model.zip",
    "contentType": "application/zip",
    "size": 123456789,
    "kind": "file"
  }'
```

## 14.2 Node.js - create product com idempotencia

```ts
const response = await fetch("https://api.voxelshelf.com/v1/creator/products", {
  method: "POST",
  headers: {
    Authorization: `Bearer ${process.env.VS_API_KEY}`,
    "Content-Type": "application/json",
    "Idempotency-Key": "create-product-20260220-001",
    "X-Request-Id": "req_node_001",
  },
  body: JSON.stringify(payload),
});
```

## 14.3 Python - polling de import job

```python
import requests

headers = {"Authorization": "Bearer vs_live_xxx"}
job_id = "job_123"
resp = requests.get(f"https://api.voxelshelf.com/v1/creator/import-jobs/{job_id}", headers=headers, timeout=30)
print(resp.status_code, resp.json())
```

## 15) Testes de aceite obrigatorios (v1)

1. Happy path upload: presign -> PUT storage -> create product.
2. Replay de `Idempotency-Key` nao duplica criacao.
3. `429` retorna headers de rate limit e corpo consistente.
4. Erro de validacao respeita envelope unico.
5. Import job com falha parcial retorna resultado por item.
6. Bundle update preserva regras de desconto/cardinalidade.
7. PKCE invalido e rejeitado no OAuth token.
8. Revogacao de chave invalida requests imediatamente.
9. Upload orfao expira e cleanup remove sem afetar assets finalizados.
10. OpenAPI e exemplos sincronizados na CI.

## 16) Rollout

1. D0: documento + OpenAPI draft + repo base.
2. D1: alpha privado com creators internos.
3. D2: sandbox publico free com quotas rigidas.
4. D3: planos pagos + import jobs em GA.

Kill criteria:

1. abuso acima do limite por 2 ciclos;
2. custo por creator acima do alvo por 2 ciclos;
3. erro `5xx` sustentado acima do SLO.

## 17) Referencias

1. Stripe idempotency: <https://docs.stripe.com/api/idempotent_requests>
2. Shopify bulk operations: <https://shopify.dev/docs/api/usage/bulk-operations/queries>
3. AWS S3 multipart upload: <https://docs.aws.amazon.com/AmazonS3/latest/userguide/mpuoverview.html>
4. Google resumable upload: <https://cloud.google.com/storage/docs/performing-resumable-uploads>
5. OAuth 2.0: <https://www.rfc-editor.org/rfc/rfc6749>
6. PKCE: <https://www.rfc-editor.org/rfc/rfc7636>
7. OAuth 2.0 Security BCP: <https://www.rfc-editor.org/rfc/rfc9700>
8. HTTP 429: <https://www.rfc-editor.org/rfc/rfc6585>
9. RateLimit headers: <https://www.rfc-editor.org/rfc/rfc9333>
10. Referencia comparativa: `D:\cults3d-api-docs`
