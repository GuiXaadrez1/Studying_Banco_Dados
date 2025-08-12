## Introdução

A configuração dinâmica de containers é fundamental para tornar suas aplicações flexíveis, seguras e reutilizáveis em múltiplos ambientes (desenvolvimento, teste, produção).
Separar código e configuração permite o princípio de 12-Factors Apps e melhora a manutenção, escalabilidade e segurança do sistema.

O Docker Compose oferece mecanismos para essa separação:

- Variáveis de ambiente — definem parâmetros no momento da execução.

- Arquivos .env — centralizam variáveis para diferentes ambientes.

- Segredos (secrets) — armazenam informações sensíveis com controle de acesso aprimorado.

## Variáveis de Ambiente (Environment Variables)

Definição e Funcionamento: Variáveis de ambiente são pares chave-valor disponíveis dentro do container. São injetadas pelo Docker no momento da criação do container e acessadas pela aplicação via APIs do sistema operacional.

- Sintaxe no docker-compose.yml

```yaml
services:
  api:
    image: my-api:latest
    environment:
      - NODE_ENV=production
      - DB_HOST=db
      - DB_USER=root
      - DB_PASS=senha123
```     

Ou como mapeamento chave-valor:

```yaml
    environment:
      NODE_ENV: production
      DB_HOST: db
      DB_USER: root
      DB_PASS: senha123
```

**Características**:

Variáveis definidas no environment são visíveis em docker inspect, portanto não são seguras para dados confidenciais.

Podem ser sobrescritas pelo arquivo .env ou variáveis do sistema host (shell).

## Arquivo .env

Propósito

Centralizar as variáveis em um arquivo externo para:

- Não poluir o arquivo docker-compose.yml com dados específicos.

- Facilitar troca de ambientes (dev, staging, prod).

- Não versionar senhas reais em repositórios públicos.

Exemplo .env:

```env

NODE_ENV=production
DB_HOST=db
DB_USER=root
DB_PASS=senha123
```

Uso no Compose

```yaml
services:
  api:
    image: my-api:latest
    environment:
      NODE_ENV: ${NODE_ENV}
      DB_HOST: ${DB_HOST}
      DB_USER: ${DB_USER}
      DB_PASS: ${DB_PASS}
```

## Hierarquia e Substituição

O Compose lê .env no diretório atual automaticamente.

Variáveis do shell têm precedência sobre .env.

Variáveis faltantes podem ter valores padrão com ${VAR:-default}.

## Comando docker compose --env-file

```bash
docker compose --env-file
```

### O que é?

Por padrão, o Docker Compose lê automaticamente um arquivo chamado .env no diretório onde está o docker-compose.yml. Esse arquivo define variáveis de ambiente que podem ser referenciadas no Compose via ${VAR}.

Porém, às vezes você quer:

- Usar arquivos .env com nomes diferentes (ex: .env.production, .env.dev, .env.testing).

- Controlar exatamente qual arquivo de ambiente será usado na execução do Compose.

- Ter múltiplos ambientes e escolher qual carregar sem renomear arquivos.

Para isso, você usa a flag:

```bash
docker compose --env-file caminho/para/outro-arquivo.env up
```

### Exemplo prático

Suponha que você tenha dois arquivos:

.env.dev

.env.prod

E queira rodar seu compose com .env.prod:

```bash
docker compose --env-file .env.prod up -d
```

### Diferença para o .env padrão

Sem --env-file, o Compose sempre tenta carregar .env no diretório atual.

Com --env-file, você especifica outro arquivo, substituindo o padrão.

O arquivo especificado deve ter o formato de variáveis ambiente:

```env
VAR1=valor1
VAR2=valor2
```

### Importante

O arquivo .env não é enviado para dentro do container — ele é usado somente na substituição das variáveis do docker-compose.yml.

Se quiser passar variáveis para o container, você deve usar a chave environment no Compose.

A flag --env-file facilita CI/CD, deploys em múltiplos ambientes, e evita que você precise editar o docker-compose.yml para trocar configurações.

Sintaxe resumida

```bash
docker compose --env-file <arquivo> up
```

### Uso avançado com .env

No docker-compose.yml:

```yaml
services:
  app:
    image: myapp
    environment:
      - API_KEY=${API_KEY}
```

No .env.prod:

```env
API_KEY=chave_prod_123
```

No .env.dev:

```env
API_KEY=chave_dev_456
```

Executando com:

```bash
docker compose --env-file .env.prod up
```

vai injetar API_KEY=chave_prod_123.

## Segredos (Secrets)

### Problema que resolve

Variáveis em environment podem ser expostas facilmente (logs, docker inspect, histórico do 
Git).

Secrets fornecem uma camada de proteção para dados sensíveis.

### Como funcionam? 

Dados são armazenados localmente (ou no Docker Swarm/Kubernetes).

São montados em containers em arquivos temporários, geralmente em /run/secrets/<nome>.

Não ficam expostos como variáveis de ambiente.

## Exemplo

Arquivo do segredo:

db_password.txt contendo senha_super_secreta

docker-compose.yml:

```yaml
version: "3.9"

services:
  db:
    image: mysql:8.0
    secrets:
      - db_password
    environment:
      MYSQL_ROOT_PASSWORD_FILE: /run/secrets/db_password

secrets:
  db_password:
    file: ./db_password.txt
```

### Importante

Nem toda aplicação suporta leitura de segredos via arquivo — adaptar código é necessário.

secrets funcionam melhor em orquestradores (Swarm, Kubernetes), mas também são suportados localmente pelo Compose.

## Configuração Dinâmica e Defaults

Substituição com defaults

```yaml
environment:
  MODE: ${MODE:-development}
```

Se MODE não estiver definido no .env nem no shell, o valor development será usado.

Passagem dinâmica via CLI

```bash
MODE=production docker-compose up
```

Boas Práticas e Segurança

Não versionar arquivos .env com segredos reais. Use .env.example com placeholders.

Prefira secrets para dados críticos.

Evite colocar senhas diretamente no docker-compose.yml.

Use .env para variáveis não sensíveis e parâmetros de ambiente.

Documente as variáveis necessárias para cada ambiente.

## Considerações Técnicas Finais

O uso correto das variáveis e segredos permite arquiteturas twelve-factor app, que são:

- Portáteis entre ambientes.

- Escaláveis e seguras.

- Separar configuração do código facilita pipelines CI/CD, testes automatizados e rollback seguro.

- Segredos exigem adaptação da aplicação para ler do sistema de arquivos, diferente de variáveis.



