# Introdução 

Este documento tem como objetivo fornecer noções básicas sobre fluxos de trabalho (workflows) no GitHub Actions.

Você aprenderá o que são, como funcionam e quais são os principais elementos para configurar a automação do seu projeto usando arquivos .yaml.

# Fluxo de trabalho

Um workflow define a automação necessária para o seu projeto.
Ele especifica:

- Eventos que devem disparar o fluxo.

- Tarefas (jobs) que devem ser executadas automaticamente.

Esses fluxos de trabalho são escritos em arquivos YAML (extensão .yml ou .yaml).
No repositório, eles ficam armazenados no diretório:

  .github/workflows/

**observação:**  Workflows significa fluxos de trabalho em inglês.

## Principais cláusulas que definem um workflow

| Cláusula   | Descrição                                                            |
| ---------- | -------------------------------------------------------------------- |
| `name:`    | Define o **nome do workflow** (aparece na interface do GitHub).      |
| `on:`      | Especifica os **eventos gatilho** (push, pull\_request, cron, etc.). |
| `jobs:`    | Lista os **trabalhos** (jobs) que serão executados.                  |
| `runs-on:` | Define o **sistema operacional** do runner (ex: `ubuntu-latest`).    |
| `steps:`   | Etapas executadas dentro de cada job.                                |
| `uses:`    | Utiliza uma **ação reutilizável** da comunidade ou oficial.          |
| `run:`     | Executa **comandos de shell** dentro do runner.                      |


## Exemplo de um arquivo.yaml:

```yaml
# Nome do workflow, aparece na aba Actions do GitHub
name: CI Pipeline

# Evento(s) que disparam o workflow
on:
  push:          # Sempre que houver push em qualquer branch
  pull_request:  # E também em pull requests

# Jobs a serem executados
jobs:
  build:  # Nome do job principal
    runs-on: ubuntu-latest # Runner: sistema operacional onde o job roda (máquina virtual)

    steps:
      # Passo 1 — Faz checkout do código do repositório
      - name: Checkout do código
        uses: actions/checkout@v3

      # Passo 2 — Configura o Node.js
      - name: Configura Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18' # Versão do Node a usar

      # Passo 3 — Instala as dependências do projeto
      - name: Instala dependências
        run: npm install

      # Passo 4 — Executa os testes
      - name: Roda testes
        run: npm test

      # Passo 5 — Gera build (opcional, depende do seu projeto)
      - name: Gera build
        run: npm run build

  # Outro job — Exemplo: Linter rodando em paralelo
  lint:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout do código
        uses: actions/checkout@v3

      - name: Configura Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'

      - name: Instala dependências
        run: npm install

      - name: Roda Linter
        run: npm run lint

```

## O que cada parte faz?

| Bloco            | Descrição                                                                                        |
| ---------------- | ------------------------------------------------------------------------------------------------ |
| `name`           | Nome visível do pipeline na interface do GitHub                                                  |
| `on`             | Define os gatilhos: push, pull\_request, schedule (cron) ou até `workflow_dispatch` (manual)     |
| `jobs`           | Bloco principal — cada `job` é independente, roda em VM separada                                 |
| `runs-on`        | Runner (SO base) — `ubuntu-latest` é o mais usado, mas pode ser `windows-latest`, `macos-latest` |
| `steps`          | Lista de etapas — cada passo é executado sequencialmente dentro do job                           |
| `uses`           | Refere-se a **Ações Reutilizáveis** — como `actions/checkout` para clonar o repo                 |
| `run`            | Executa um comando de terminal dentro do runner                                                  |
| `with`           | Passa parâmetros para a ação (`uses`) — ex: versão do Node                                       |
| `jobs` múltiplos | Você pode rodar jobs em paralelo ou definir dependências entre eles com `needs:`                 |

## Fluxo real

1️⃣ Ao fazer push ou abrir um pull request, o Actions dispara.

2️⃣ Ele provisiona uma máquina Ubuntu, clona seu repositório (checkout).

3️⃣ Instala Node.js na versão especificada.

4️⃣ Instala dependências com npm install.

5️⃣ Executa scripts definidos no package.json (test, build, lint...).

6️⃣ Marca o job como sucesso ✅ ou falha ❌, bloqueando merge se configurado.

## 🗂️ Onde fica

Este arquivo sempre fica em:

    .github/workflows/ci.yml

Você pode ter vários workflows no mesmo repositório:

    ci.yml (build + testes)

    deploy.yml (deploy automático)

    codeql.yml (análise de segurança)