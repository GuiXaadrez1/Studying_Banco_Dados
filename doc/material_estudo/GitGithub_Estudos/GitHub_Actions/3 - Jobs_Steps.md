# Introdução 

No GitHub Actions, tudo gira em torno de workflows automatizados.
Esses workflows são divididos em jobs, e cada job é formado por steps.
Essa estrutura faz o Actions ser modular, paralelo e controlável — é isso que transforma um simples script num pipeline profissional.

## ⚙️ O que são jobs?

✅ Definição:

    Um job é um bloco de tarefas que roda numa máquina virtual isolada (chamada runner).

Características principais de um job:

- Tem nome único dentro do jobs:.

- É executado isoladamente: cada job é independente, a não ser que você use needs: para definir ordem.

- Pode rodar em paralelo com outros jobs (ótimo para builds multi-OS ou multi-linguagem).

- Dentro dele você define o SO (runs-on:) e as etapas (steps).

### 🎯 Para que servem os jobs?

Dividir o pipeline em etapas lógicas maiores:

- Exemplo: build, test, deploy, lint, audit.

Ganhar paralelismo:

- Enquanto um job testa Node 18, outro testa Node 20.

Controlar dependências:

- deploy só roda se build passar: needs: build.

## Estrutura de um job

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      # steps aqui dentro

```

| Campo      | Função                                                     |
| ---------- | ---------------------------------------------------------- |
| `runs-on:` | Define o **SO do runner** (Ubuntu, Windows, macOS).        |
| `steps:`   | Lista **as tarefas** que esse job executa, na ordem.       |
| `needs:`   | (opcional) Define **dependências** de execução entre jobs. |

## ⚙️ O que são steps?

✅ Definição:

    Um step é uma única tarefa dentro de um job.
    É o bloco atômico de execução — cada step roda um comando ou uma ação (action).

### 🎯 Para que servem os steps?

- Executar comandos de shell: run:.

- Usar ações reutilizáveis da comunidade: uses:.

- Controlar o fluxo: cada step depende do anterior (executa em sequência).

- Encapsular lógica repetida em blocos claros.

## Estrutura de um step

```yaml
steps:
  - name: Checkout do código
    uses: actions/checkout@v4

  - name: Instalar dependências
    run: npm install

  - name: Roda testes
    run: npm test
```

| Campo   | Função                                             |
| ------- | -------------------------------------------------- |
| `name:` | Nome descritivo que aparece nos logs.              |
| `uses:` | Usa uma **ação** pronta do marketplace ou oficial. |
| `run:`  | Executa um **comando de shell** dentro do runner.  |
| `with:` | Passa **parâmetros** para uma ação (`uses:`).      |
| `env:`  | Variáveis de ambiente **só daquele step**.         |

## Como jobs e steps se relacionam

| Relação                | Detalhe                                                                        |
| ---------------------- | ------------------------------------------------------------------------------ |
| 1 workflow             | Pode ter **vários jobs**.                                                      |
| 1 job                  | Deve ter **um ou mais steps**.                                                 |
| Jobs                   | São **executados em paralelo**, a menos que use `needs:`.                      |
| Steps                  | São **executados em sequência**, dentro do mesmo job.                          |
| Runner                 | Cada job roda **num runner separado**.                                         |
| Steps dentro de um job | Compartilham o mesmo runner — um step pode criar arquivos para o próximo usar. |

##  Exemplo completo:

```yaml
name: Exemplo de Jobs e Steps

on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Instala Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'

      - name: Instala dependências
        run: npm install

      - name: Roda testes
        run: npm test

  deploy:
    runs-on: ubuntu-latest
    needs: build # Só roda se build passar
    steps:
      - name: Deploy fictício
        run: echo "Deploy para produção realizado!"

```

Análise:

    Workflow roda quando fizer push na main.

    Tem 2 jobs:

    build ➜ Checkout, instala Node, instala dependências, testa.

    deploy ➜ Depende de build. Só roda se build passar.

    Cada job roda em máquina separada.

    Dentro de cada job, steps são sequenciais.

## Boas práticas

✅ Dê nomes claros a jobs e steps.
✅ Divida tarefas lógicas em vários jobs se fizer sentido (test, build, deploy).
✅ Use needs: para controlar ordem de execução.
✅ Prefira uses: para tarefas comuns (checkout, setup linguagens) — evita reescrever script.
✅ Cada step deve ser pequeno e claro: fácil de debugar nos logs.

## Resumo final 

| Conceito  | Significado                                             |
| --------- | ------------------------------------------------------- |
| **Job**   | Conjunto de tarefas executadas num runner **isolado**.  |
| **Step**  | Ação única dentro de um job (um comando ou uma action). |
| **Jobs**  | Executam **paralelamente** (se não usar `needs:`).      |
| **Steps** | Executam **em sequência**, dentro de cada job.          |
