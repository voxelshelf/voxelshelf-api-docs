# OpenAPI Governance (Creator API v1)

Status: Proposed  
Owner: API Platform + PM  
Last updated: 2026-02-20

## 1) Politica base

1. OpenAPI e a fonte de verdade da API publica.
2. Nenhuma rota publica entra em producao sem contrato OpenAPI.
3. SDKs e examples devem ser derivados do contrato.

## 2) Arquivo canonical

1. Caminho canonical (monorepo): `openapi/v1.yaml`.
2. Caminho canonical (repo publico quando separado): `openapi/voxelshelf-api.v1.yaml` (repo `voxelshelf-api`).
3. Superficie publica de docs no app: `/developers/api`.
4. Link canônico para documentacao externa (GitHub) controlado por `NEXT_PUBLIC_API_DOCS_URL`.
5. Formato: OpenAPI 3.1.
6. Convencao de naming:
   - caminhos em kebab-case
   - schemas em PascalCase
   - campos em camelCase

## 3) Padrões obrigatorios de contrato

1. Todo endpoint deve documentar:
   - auth required/scopes
   - request schema
   - response schema
   - codigos de erro
   - exemplos
2. Envelope unico de erro:
`{ error: { code, message, details, requestId, retryable } }`.
3. Headers padrao documentados:
   - `Authorization`
   - `X-Request-Id`
   - `Idempotency-Key` (quando aplicavel)
   - `RateLimit-Limit`, `RateLimit-Remaining`, `RateLimit-Reset`

## 4) Versionamento e deprecacao

1. SemVer no contrato.
2. Regra:
   - patch: ajustes nao-breaking
   - minor: adicoes backward compatible
   - major: mudancas breaking
3. Deprecacao:
   - marcar endpoint/schema como deprecated
   - registrar data de sunset
   - janela minima de 90 dias

## 5) Politica de breaking changes

Considerar breaking change quando houver:

1. remocao/renomeacao de campo ou endpoint;
2. mudanca de tipo/semantica incompatível;
3. alteracao de auth/scope que quebra clientes existentes.

Processo:

1. ADR curta da mudanca.
2. aprovacao PM + engineering owner.
3. changelog explicito com migracao.
4. release major se aplicavel.

## 6) Lint e qualidade de contrato

CI obrigatoria:

1. lint OpenAPI (style + completeness).
2. validacao de exemplos.
3. diff de breaking changes contra baseline da main.
4. checagem de campos obrigatorios de erro e rate-limit.

Falha em qualquer check bloqueia merge.

## 7) Sincronizacao com SDK e docs

1. SDK TypeScript e Python gerados a partir do contrato.
2. docs de endpoint derivadas da especificacao.
3. PR que altera contrato deve atualizar examples afetados.
4. Tag de release publica contrato + SDK + changelog na mesma versao.

## 8) Matriz de ownership

1. API Platform: contrato, lint, pipeline, release.
2. PM: escopo funcional, deprecacoes e impacto em integradores.
3. Security: auth/scopes/rate-limit, revisao de risco.
4. Support: feedback loop de erros comuns para docs/examples.

## 9) Checklist de PR (OpenAPI)

1. O endpoint novo/alterado esta no OpenAPI.
2. Existe exemplo de request/response.
3. Erros foram mapeados no envelope padrao.
4. Scopes e auth estao explicitos.
5. Changelog foi atualizado.
6. Breaking diff foi analisado e aprovado (se houver).

## 10) Demand Elegance gate

Toda mudanca na API deve responder:

1. Existe caminho simples sem forcar batch?
2. A solucao reduz ou aumenta custo operacional no v1?
3. A complexidade extra e realmente necessaria agora?
4. O contrato ficou mais claro para integrador externo?

Se falhar em qualquer ponto, refinar antes de merge.

## 11) Criterios de aceite da governanca

1. OpenAPI-first documentado e adotado.
2. CI com lint + breaking check ativa.
3. Processo de deprecacao/sunset formalizado.
4. SDK/docs sincronizados por release.
5. Demand Elegance usado como gate explicito.
