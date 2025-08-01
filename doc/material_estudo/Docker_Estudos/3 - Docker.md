# Introdução

Esta documentação tem como objetivo explicar de forma detalhada **o que é o Docker**, como ele funciona, seus **benefícios**, **desvantagens** e uma visão resumida de sua **arquitetura**.

---

## 🐳 O que é o Docker?

O **Docker** é uma **plataforma de containers** que permite **empacotar, distribuir e executar aplicações** de forma **leve, isolada e portátil**.  
Ele utiliza recursos do sistema operacional (principalmente do kernel Linux) para criar **ambientes isolados** chamados de **containers**.

Docker se tornou popular porque **simplificou a containerização**, que já existia em conceitos anteriores (chroot, LXC), mas era difícil de usar de forma padronizada.

---

## ⚙️ Como o Docker funciona?

O Docker funciona utilizando **componentes do kernel Linux**:

- **Namespaces**: garantem isolamento de processos, rede, PID, sistema de arquivos.

- **cgroups**: limitam e gerenciam recursos de CPU, RAM, disco.

- **UnionFS (OverlayFS)**: permite imagens em camadas, otimizando espaço e distribuição.

O Docker cria **imagens** baseadas em um **Dockerfile**:

- Cada comando (`FROM`, `RUN`, `COPY` etc.) cria uma camada.

- Imagens podem ser **versionadas**, compartilhadas em repositórios (registries).

Para executar uma aplicação, o Docker **instancia um container** a partir da imagem.  
Cada container é:

- Isolado.

- Efêmero por padrão (se não usar volumes).

- Leve, pois compartilha o kernel do host.

---

## ✅ Benefícios do Docker

- **Portabilidade**: “Build once, run anywhere”. O mesmo container roda em qualquer ambiente que tenha Docker Engine.

- **Consistência**: Reduz o problema do “funciona na minha máquina”.

- **Leveza**: Containers são muito menores e mais rápidos de iniciar que VMs.

- **Isolamento**: Cada container roda como um processo isolado.

- **Escalabilidade**: Ideal para aplicações distribuídas e microserviços.

- **Integração com CI/CD**: Pipeline moderno se baseia em containers.

---

## ⚠️ Desvantagens do Docker

- **Compartilhamento de Kernel**: Não isola kernels diferentes — todos os containers usam o mesmo kernel do host.

- **Menor isolamento que VMs**: Falhas de segurança podem, em teoria, “escapar” se o runtime estiver mal configurado.

- **Persistência de dados**: Por padrão, containers são descartáveis — é necessário configurar volumes para persistir dados.

- **Gerenciamento complexo em larga escala**: Docker sozinho não resolve orquestração — precisa de ferramentas como Kubernetes.

---

## 🧬 Arquitetura do Docker

A arquitetura do Docker é composta por três camadas principais:

### 1️⃣ Docker Engine

O **motor principal**, composto por:

- **Docker Daemon (`dockerd`)**: Gerencia containers, imagens, redes e volumes.
- **API REST**: Interface para comunicação com o daemon.
- **CLI (`docker`)**: Ferramenta de linha de comando para executar comandos.

---

### 2️⃣ Imagens e Containers

- **Imagens**: São “moldes” imutáveis, compostos por camadas, construídos via `Dockerfile`.

- **Containers**: São instâncias em execução de uma imagem — equivalem a processos isolados.

---

### 3️⃣ Registries

- **Registries**: São repositórios de imagens (ex: Docker Hub, GitHub Packages, registries privados).

- **Push/Pull**: É possível publicar (`push`) e obter (`pull`) imagens para compartilhar com times e ambientes.

---

## 🗂️ Visão Geral da Arquitetura

```plaintext
+----------------------+
|   Docker CLI / API   |
+----------+-----------+
           |
+----------v-----------+
|    Docker Daemon     |
|  (dockerd)           |
+----------+-----------+
           |
+----------v-----------+
| Imagens  | Containers|
+----------------------+
           |
+----------v-----------+
|     Registries       |
+----------------------+
```

## Visão Geral da Arquitetura mais completa

<img src = "https://imgs.search.brave.com/HxziJ6p1VpZO-VT_qgE0v8fxQLggdMf9vnWoYT8cHVY/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9tZWRp/YS5nZWVrc2Zvcmdl/ZWtzLm9yZy93cC1j/b250ZW50L3VwbG9h/ZHMvMjAyMjEyMDUx/MTUxMTgvQXJjaGl0/ZWN0dXJlLW9mLURv/Y2tlci5wbmc"/>

## Tecnologias do ecossistema Docker

### Docker Engine

- O que é:
    
    É o coração do Docker — o runtime responsável por criar, executar e gerenciar containers.

- Componentes principais:

    Docker Daemon (dockerd)

    Processo principal que fica rodando em background.

    Gerencia containers, imagens, redes, volumes.

    Recebe comandos via API REST.

- API REST

    Interface que permite comunicação entre clientes (CLI, Compose, Swarm) e o daemon.

    Terceiros podem construir ferramentas integradas (ex: GUIs, plugins).

- Container Runtime

    É a camada que realmente instancia os containers, usando tecnologias como containerd, runc (parte do padrão OCI - Open Container Initiative).

Função prática:

    Toda vez que você executa docker run, docker build ou docker stop, quem realiza essas operações é o Docker Engine, orquestrando namespaces, cgroups, rede virtual, overlayFS e outros recursos do kernel.

### Docker Hub

- O que é:

    É o registro público oficial de imagens Docker.
    Funciona como um GitHub para imagens.

- Funções:

    Armazena imagens públicas e privadas.

    Permite que você puxe (pull) imagens prontas (ex.: nginx, mysql).

    Permite que você publique (push) suas próprias imagens.

    Garante versionamento de imagens com tags (ex.: python:3.11-alpine).

- Prática:

    É o padrão de onde o Docker faz pull se não especificar outro registry.
    Você pode usar docker login para autenticar e subir suas próprias imagens.

### Docker Compose

- O que é:

    É uma ferramenta para definir e executar múltiplos containers Docker usando um arquivo YAML.

- Para que serve:

    Orquestrar multi-containers (ex.: um app web, um banco de dados, um cache).

    Gerenciar redes, volumes e variáveis de ambiente.

    Subir, derrubar e escalar stacks completas com comandos simples: docker-compose up / down.

- Arquivo principal:

    docker-compose.yml → descreve:

    Services: containers e suas configurações.

    Networks: redes virtuais privadas.

    Volumes: persistência de dados entre containers.

Exemplo real - um docker-compose.yml pode definir:

```yaml
version: '3'
services:
  web:
    build: .
    ports:
      - "80:80"
  db:
    image: postgres
    environment:
      POSTGRES_PASSWORD: example
```

### Docker Swarm 

- O que é:

    É a ferramenta de orquestração nativa do Docker, usada para rodar containers em cluster.

- Para que serve:

    Gerenciar múltiplos hosts Docker como se fossem um só.

    Distribuir containers em vários nós (máquinas físicas ou VMs).

    Fazer balanceamento de carga, replicação e atualização de serviços.

- Arquitetura:

    Managers: coordenam o cluster.

    Workers: executam containers.

- Por que existe:

    Para projetos menores ou ambientes onde Kubernetes é muito pesado, o Swarm é mais simples e integrado nativamente ao Docker Engine (docker swarm init, docker service create).

- Status atual:

    Ainda funcional, mas muitos times preferem Kubernetes para produção em larga escala.

### Docker Registry

- O que é:

    É o componente que armazena imagens Docker, pode ser:

    Público: como o Docker Hub.

    Privado: sua empresa hospeda seu próprio Registry.

- Para que serve:

    Armazenar imagens Docker construídas internamente.

    Prover controle de acesso (login, permissões).

    Integrar pipelines de CI/CD.

- Ferramenta oficial:

    Docker Distribution (antes conhecido como Docker Registry).

    Pode ser implantado localmente: registry:2 (imagem oficial).

- Fluxo típico:

    docker build → cria imagem.

    docker tag → dá um nome com endereço do Registry.

    docker push → envia para Registry.

    docker pull → recupera em outro host.

### Docker CLI

- O que é:

    É a interface de linha de comando (docker) usada para interagir com o Docker Engine via API REST.

- Funções:

    Criar imagens (docker build).

    Rodar containers (docker run).

    Listar containers (docker ps).

    Gerenciar redes (docker network).

    Gerenciar volumes (docker volume).

    Gerenciar Swarm (docker swarm, docker service).

    Fazer login/logout em registries (docker login).

- Por que é importante:

    A CLI é a principal ferramenta do desenvolvedor no dia a dia, altamente scriptável, usada em pipelines de automação e ambientes de CI/CD.

## Resumo do Ecossistema

| Tecnologia          | Função Principal                           |
| ------------------- | ------------------------------------------ |
| **Docker Engine**   | Runtime que cria/roda containers           |
| **Docker Hub**      | Registry público para compartilhar imagens |
| **Docker Compose**  | Orquestra múltiplos containers via YAML    |
| **Docker Swarm**    | Orquestração nativa em cluster             |
| **Docker Registry** | Repositório privado ou público de imagens  |
| **Docker CLI**      | Interface de comando para tudo             |
