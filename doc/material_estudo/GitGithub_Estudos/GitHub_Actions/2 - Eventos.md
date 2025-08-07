# Introdução 

Neste guia, você verá como funcionam os eventos que disparam um workflow no GitHub Actions.

## Como funcionam os eventos?

No GitHub Actions, os eventos são configurados usando a cláusula on: dentro do arquivo de workflow.

Um evento é uma ação no repositório — como um push, um pull_request ou até uma ação manual — que faz o workflow iniciar automaticamente.

## Exemplos práticos

```yaml

# Dispara o workflow quando houver um push em qualquer branch
on:
  push:  # Evento: push
    branches: 
      - '*'  # O asterisco significa 'qualquer branch'

# Dispara o workflow quando alguém abrir um Pull Request para a branch main
on:
  pull_request:  # Evento: pull request
    branches:
      - main

# Dispara manualmente pelo botão "Run workflow" na interface do GitHub
on:
  workflow_dispatch:  # Evento manual

# Dispara automaticamente todo dia à meia-noite (agendado por cron)
on:
  schedule:
    - cron: '0 0 * * *'  # Formato cron (min hora dia mês dia-da-semana)
    # Este cron roda todos os dias às 00:00 UTC
```

### O que é schedule:?

No GitHub Actions, a cláusula schedule: é um evento especial que agenda a execução automática de um workflow baseado em um padrão de tempo — usando expressão cron.

Em outras palavras:

    schedule - serve para rodar tarefas em horários fixos, sem depender de push, pull request ou gatilho manual.

### Quando usar schedule:?

- ✅ Tarefas periódicas, como:

    Backup automático.

    Verificar dependências desatualizadas.

    Rodar testes de segurança toda madrugada.

    Gerar relatórios diários, semanais ou mensais.

### Como funciona por baixo:

O schedule: usa cron, o mesmo formato usado em sistemas Linux para agendar tarefas.

Você define minuto, hora, dia do mês, mês, dia da semana.

O GitHub executa o workflow automaticamente, mesmo que ninguém faça push.

###  Exemplo real com schedule:

```yaml
on:
  schedule:
    - cron: '0 3 * * *' # Roda todos os dias às 03:00 UTC

```
Tradução do cron:

```bash

0 3 * * *  
│ │ │ │ │  
│ │ │ │ └─ Dia da semana (0–7)  
│ │ │ └──── Mês (1–12)  
│ │ └──────── Dia do mês (1–31)  
│ └──────────── Hora (0–23)  
└──────────────── Minuto (0–59)

```

### Importante

O horário do cron é sempre em UTC, não na sua hora local.

Se quiser rodar em horário do Brasil, ajuste o cron.

Exemplo: para rodar 00:00 Brasília (UTC-3) ➜ cron: 0 3 * * * (porque 00:00 BRT = 03:00 UTC).

## Resumo de schedule: :

| Termo       | Significado                                       |
| ----------- | ------------------------------------------------- |
| `schedule:` | Evento para **agendar execuções automáticas**.    |
| `cron:`     | Expressão de tempo para definir **quando rodar**. |
| UTC         | Horário padrão, ajuste se necessário.             |

## Resumo de eventos on:

on: → Cláusula que define os eventos que vão acionar o workflow.

Pode usar um evento só ou vários combinados.

Exemplos comuns: push, pull_request, workflow_dispatch, schedule.


