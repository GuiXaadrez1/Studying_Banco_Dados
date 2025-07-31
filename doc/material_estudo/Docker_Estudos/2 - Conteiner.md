# Introdução

Esta documentação tem como objetivo explicar de forma detalhada **o que é um container**, como ele funciona, seus **benefícios**, **desvantagens**, **diferenças em relação à máquina virtual** e uma visão **arquitetural interna**.

---

## 📦 O que é um Container?

Um **container** é uma **unidade de software executável** que empacota:
- **Código da aplicação**
- **Dependências**
- **Bibliotecas**
- **Configurações de ambiente**

Tudo isso isolado do sistema host, mas **compartilhando o mesmo kernel** do sistema operacional.  

Assim, o container roda sempre da **mesma forma**, independentemente do ambiente onde for executado.

---

## ⚙️ Como funciona?

Containers utilizam recursos do kernel do Linux (ou Windows) para criar **isolamento a nível de processo**.

Os principais recursos são:
- **Namespaces**: isolam recursos como rede, sistema de arquivos, PID, usuários.
- **cgroups**: controlam limites de uso de CPU, memória, disco.
- **UnionFS** (como OverlayFS): permite camadas de arquivos para criar imagens reutilizáveis.

O container **não virtualiza o hardware**, ele **aproveita o kernel do host** para ser muito mais leve e iniciar rapidamente.

---

## ✅ Benefícios

- **Leveza**: Containers não carregam um SO completo, só processos e dependências.
- **Startup instantâneo**: Containers iniciam em segundos.
- **Consistência**: “Funciona na minha máquina” = funciona em produção.
- **Escalabilidade**: Ideal para microserviços e aplicações distribuídas.
- **Portabilidade**: Executa em qualquer ambiente que tenha o runtime (Docker Engine).
- **Isolamento**: Cada container é isolado do outro.


## ⚠️ Desvantagens

- **Compartilhamento de kernel**: Containers não rodam kernels diferentes; se o kernel host falhar, todos os containers são afetados.

- **Menor isolamento que VMs**: Falhas de segurança podem escapar do container se houver brechas no runtime.

- **Persistência de dados**: Containers são efêmeros (tempo de vida curto, temporários) por padrão, exige configuração de volumes.

- **Gerenciamento em larga escala**: Sozinho, o Docker não orquestra clusters complexos — precisa de ferramentas como Kubernetes.

## 🆚 Containers vs Máquinas Virtuais

| Aspecto | Container | Máquina Virtual |
|----------------|----------------|----------------|
| **Kernel** | Compartilha o kernel do host | Cada VM roda seu próprio kernel |
| **Tamanho** | Leve (MBs) | Pesada (GBs) |
| **Inicialização** | Segundos | Minutos |
| **Isolamento** | A nível de processo | A nível de hardware/hipervisor |
| **Portabilidade** | Alta | Média |
| **Segurança** | Isolamento mais leve | Isolamento mais forte |

---

## 🧬 Arquitetura Interna

A arquitetura de containers (exemplo Docker) inclui os seguintes componentes:

### 1️⃣ **Docker Engine**  

- **Servidor Docker Daemon (`dockerd`)**: Gerencia imagens, containers, redes e volumes.
- **API REST**: Interface para comandos Docker.
- **CLI (`docker`)**: Ferramenta de linha de comando.

### 2️⃣ **Imagens Docker**  

- Empacotam camadas de sistema de arquivos, construídas via `Dockerfile`.

### 3️⃣ **Containers**  

- São instâncias de imagens em execução.

### 4️⃣ **Registries**  

- Repositórios para armazenar imagens, ex: Docker Hub.

### 5️⃣ **Drivers de Storage**  

- UnionFS para camadas de imagem.
- Volumes/bind mounts para persistência.

### 6️⃣ **Drivers de Rede**  
- Bridge, overlay, host networking.

## # 🚀 Conclusão

Containers **não substituem totalmente as VMs**, mas complementam. São ideais para **desenvolvimento ágil, CI/CD, microserviços e escalabilidade em nuvem**, enquanto VMs ainda são melhores para cenários que exigem **isolamento de kernel ou ambientes multi-SO**.