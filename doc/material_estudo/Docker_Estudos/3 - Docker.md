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