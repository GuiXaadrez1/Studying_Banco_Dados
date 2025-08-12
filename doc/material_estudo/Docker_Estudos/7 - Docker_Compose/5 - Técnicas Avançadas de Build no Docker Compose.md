# Introdução

A etapa de build no Docker Compose é um ponto crítico em termos de desempenho e segurança. A aplicação de técnicas avançadas como multi-stage builds, otimização de cache e uso de build args reduz significativamente o tamanho final da imagem, diminui o tempo de implantação e minimiza superfícies de ataque.

## Multi-stage Builds
Permite segmentar o processo de build em múltiplas fases.

Vantagens:

- Redução do tamanho da imagem final.

- Eliminação de dependências de desenvolvimento no ambiente de produção.

- sSegregação de responsabilidades por estágio.

Exemplo:

```dockerfile
# Stage 1 - Build
FROM golang:1.22 AS builder
WORKDIR /src
COPY . .
RUN go build -o app main.go

# Stage 2 - Runtime
FROM debian:bookworm-slim
WORKDIR /app
COPY --from=builder /src/app .
CMD ["./app"]
```

## Otimização de Cache

O Docker mantém um cache por camada.

Estratégia ideal:

- Copiar arquivos de definição de dependências (package.json, requirements.txt) antes do código.

- Instalar dependências.

- Copiar o restante do código.

Isso evita reinstalação desnecessária quando apenas o código muda.

## Build Arguments (ARG)

Permitem parametrizar o build sem alterar o Dockerfile.

São avaliados em tempo de build (não ficam acessíveis no runtime).

```dockerfile
ARG NODE_VERSION=20
FROM node:${NODE_VERSION}
```

No Compose:

```yaml
build:
  context: .
  args:
    NODE_VERSION: 18
```

## Targets

No multi-stage build, é possível compilar até um estágio específico.

```bash
docker compose build --target builder
```

## Imagens Base Mínimas

Recomenda-se uso de versões slim ou alpine:

- Menor superfície de ataque.

- Redução no tempo de download.

- Menor consumo de espaço em disco.

## Separação de Ambientes
Ambiente de desenvolvimento:

- Volumes para hot reload.

- Configurações de debug.

## Ambiente de produção:

- Imagens imutáveis.

- restart: always.

- Sem volumes locais (exceto persistência de dados).

Execução combinada:

```bash
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```