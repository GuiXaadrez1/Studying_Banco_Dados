# Introdução

Essa anotação visa entender a diferença entre os comandos `docker start`, `docker stop`, `docker pause` e `docker unpause`, utilizados no gerenciamento do ciclo de vida de containers Docker.

---

## Entendendo a diferença entre `pause` e `unpause`, `start` e `stop`

Esses comandos são utilizados para **controlar containers em diferentes estados**, porém eles operam de formas distintas.

---

### 🟢 `docker start`

- **O que faz:** Inicia um container que está parado (`stopped`), mas que já foi criado anteriormente.

- **Importante:** Ele **não cria um novo container**. Apenas reinicia um container existente.

- **Sintaxe:**

```bash
docker start <nome_ou_id_do_container>
```

- Para iniciar e anexar ao terminal:

```bash
docker start -ai <nome_ou_id_container>
```

### 🔴 docker stop

**O que faz:** Envia um sinal SIGTERM ao processo principal do container, solicitando parada limpa, e após um tempo (timeout), envia SIGKILL.

**Utilização comum:** Parar containers que estão em execução (Up).

- **Sintaxe:**
```bash
docker stop <nome_ou_id_do_container>
```

### 🟡 docker pause

**O que faz:** Suspende temporariamente todos os processos dentro do container via cgroups freezer do kernel Linux.

**Importante:** O container continua existindo e rodando em segundo plano, mas não executa mais nenhum processo até ser despausado.

Sintaxe:

```bash
docker pause <nome_ou_id_do_container>
```

**Exemplo de uso:** útil quando você precisa economizar recursos momentaneamente sem parar completamente o container.

### 🟢 docker unpause

**O que faz:** Retoma a execução dos processos de um container que foi pausado com docker pause.

- **Sintaxe:**

```bash
docker unpause <nome_ou_id_do_container>
```

### Resumo Geral

| Comando          | Ação                                | Quando usar                                       |
| ---------------- | ----------------------------------- | ------------------------------------------------- |
| `docker start`   | Inicia um container parado          | Para reativar um container que foi parado         |
| `docker stop`    | Encerra a execução do container     | Para encerrar um container corretamente           |
| `docker pause`   | Congela temporariamente o container | Para economizar recursos sem encerrar o container |
| `docker unpause` | Retoma a execução de um container   | Para continuar a execução após um `pause`         |

### Observação

- pause/unpause são relacionados à suspensão temporária de processos.

- stop/start são relacionados ao ciclo de vida de execução de containers.