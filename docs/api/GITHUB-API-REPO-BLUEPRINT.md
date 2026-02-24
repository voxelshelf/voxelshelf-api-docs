# GitHub API Hub Blueprint (`voxelshelf-api`)

Status: Proposed  
Owner: API Platform  
Last updated: 2026-02-20

## 1) Objetivo

Definir como montar o repositorio publico da API para maximizar DX com baixo custo operacional:

1. contrato claro (OpenAPI);
2. exemplos executaveis;
3. SDKs gerados;
4. docs publicas com versao;
5. CI minima e confiavel.

## 2) Escopo do repositorio

1. Publico e dedicado: `voxelshelf-api`.
2. Sem codigo sensivel de runtime do marketplace.
3. Fonte de verdade para contrato da API publica v1.

## 3) Estrutura de pastas

```text
voxelshelf-api/
  openapi/
    voxelshelf-api.v1.yaml
  docs/
    getting-started.md
    auth.md
    uploads.md
    products.md
    bundles.md
    import-jobs.md
    errors.md
    rate-limits.md
    changelog.md
  examples/
    curl/
    node/
    python/
  sdks/
    typescript/
    python/
  postman/
    voxelshelf-api-v1.postman_collection.json
  .github/workflows/
    ci.yml
    publish-docs.yml
    release-sdk.yml
  README.md
  CONTRIBUTING.md
  CODE_OF_CONDUCT.md
  SECURITY.md
  LICENSE
```

## 4) Conteudo minimo por pasta

## 4.1 `openapi/`

1. Arquivo canonical: `voxelshelf-api.v1.yaml`.
2. Componentes reaproveitaveis para erros, paginacao, auth e rate-limit.
3. Exemplos de request/response por endpoint critico.

## 4.2 `docs/`

1. Guia quickstart em 10 minutos.
2. Guia de auth (API key + OAuth PKCE).
3. Guia upload simples (sem batch).
4. Guia import job (alto volume).
5. Politica de deprecacao e versionamento.

## 4.3 `examples/`

1. cURL para todos os fluxos core.
2. Node e Python focados em publish de produto e bundles.
3. Scripts pequenos e sem dependencia pesada.

## 4.4 `sdks/`

1. SDK TypeScript gerado de OpenAPI.
2. SDK Python gerado de OpenAPI.
3. Versionamento sincronizado com tag do contrato.

## 5) CI/CD minimo (obrigatorio)

## 5.1 `ci.yml`

1. Lint de OpenAPI.
2. Validacao de exemplos (smoke de sintaxe e request shape).
3. Check de breaking changes contra baseline da main.
4. Check de links quebrados na docs.

## 5.2 `publish-docs.yml`

1. Build de docs site.
2. Publish em GitHub Pages em merge na `main`.

## 5.3 `release-sdk.yml`

1. Executa em tag SemVer (`v1.x.y`).
2. Gera SDK TypeScript/Python.
3. Publica artifacts/releases.

## 6) Governanca de versao

1. SemVer para contrato OpenAPI.
2. Mudanca breaking so em major.
3. Deprecacao com janela minima de 90 dias (salvo incidente de seguranca).
4. `docs/changelog.md` obrigatorio por release.

## 7) Padrao de PR

Todo PR precisa:

1. atualizar OpenAPI quando endpoint/shape muda;
2. incluir exemplo em `examples/` para novos fluxos;
3. atualizar docs de endpoint correspondente;
4. passar checks de CI.

## 8) Politica de contribuicao

1. Contributions externas aceitas via PR.
2. Templates obrigatorios:
   - bug report
   - feature request
   - docs issue
3. Triage com labels:
   - `api-contract`
   - `sdk`
   - `docs`
   - `breaking-change`

## 9) Security policy

1. Vulnerabilidades reportadas via `SECURITY.md`.
2. Chaves reais nunca devem aparecer em exemplos.
3. Workflow deve falhar em secrets hardcoded detectados.

## 10) Roadmap de bootstrap do repo

1. Semana 1: criar estrutura, OpenAPI draft e docs base.
2. Semana 2: examples cURL/Node/Python + CI `ci.yml`.
3. Semana 3: GitHub Pages + release SDK pipeline.
4. Semana 4: alpha docs hardening + changelog formal.

## 11) Definition of Done (repo hub)

1. Repositorio publico no ar com README claro.
2. OpenAPI v1 publicado.
3. Docs navegavel com quickstart funcional.
4. Exemplos cURL/Node/Python funcionando.
5. CI de lint + breaking change ativo.
6. Release pipeline de SDK via tag ativo.
