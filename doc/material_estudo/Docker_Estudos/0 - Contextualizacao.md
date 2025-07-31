# Introdulção
Este documento visa contextualizar como o Docker surgiu 

## O início: Servidores Físicos

Antes de qualquer virtualização, as aplicações rodavam diretamente no hardware físico, nos chamados bare-metal servers.

Um servidor era uma máquina única, com um sistema operacional (SO) instalado e todas as aplicações rodando lado a lado nesse mesmo ambiente.

### Problemas

Baixa utilização de recursos: Hardwares superdimensionados ficavam ociosos.

Ambiente compartilhado: Um erro ou conflito entre apps podia derrubar o servidor inteiro.

Escalabilidade limitada: Para escalar, comprava-se mais hardware físico.

Provisionamento lento: Instalar e configurar uma máquina nova demorava dias ou semanas.

## A revolução: Virtualização com Hypervisor

Para resolver esses problemas, surgiu a virtualização, popularizada nos anos 2000 por empresas como VMware.

É um software que permite rodar múltiplos sistemas operacionais (VMs) em uma única máquina física.

Exemplos: VMware ESXi, Microsoft Hyper-V, KVM, Xen.

Existem dois tipos:

    Tipo 1 (bare-metal): roda direto no hardware (ex.: ESXi).

    Tipo 2 (hosted): roda sobre um SO hospedeiro (ex.: VirtualBox).

### Benefícios da Virtualização

solamento: Cada VM roda seu SO isolado.

Melhor uso de hardware: Várias VMs compartilham a mesma CPU/RAM.

Provisionamento ágil: Subir novas VMs ficou rápido.

Portabilidade: VMs podem ser movidas entre servidores.

### Limites da Virtualização Tradicional

Apesar de revolucionar, a virtualização com hypervisor tem limitações:

    Overhead: Cada VM carrega um SO completo. Isso consome mais CPU, RAM e armazenamento.

    Consumo Exagerado dos recursos computacionais: VMs também consomem a mesma ou mais capacidade de processamento do hardware, seja RAM ou DISCO

    Startup lento: Inicializar uma VM demora mais tempo do que iniciar um simples processo.

    Dificuldade em escalar rapidamente: Não é tão leve quanto seria ideal.

## Containers: uma abordagem mais leve

A ideia de containers não nasceu com o Docker. Na verdade, sistemas Unix já tinham chroot (1979) — isolava diretórios para processos. Mais tarde, surgiram tecnologias como:

FreeBSD Jails (2000): Isolamento mais forte.

Solaris Zones (2004): Particionamento de SO.

LXC (Linux Containers, 2008): Avanço real, usando namespaces e cgroups do Linux.

### O que é um Container?

É um ambiente isolado a nível de processo, compartilhando o mesmo kernel do SO host.
Você empacota:

    Código da aplicação

    Bibliotecas

    Dependências

    Configuração

Assim, ele roda sempre do mesmo jeito, em qualquer host com o runtime adequado.

## O marco: nascimento do Docker (2013)

O Docker não inventou containers, mas:

    Tornou simples criar, distribuir e rodar containers.

    Trouxe uma API amigável para construir imagens.

    Implementou um sistema de imagens em camadas, reaproveitando partes comuns.

    Permitiu versionamento, deploy e rollback de containers de forma limpa.

### Impacto no desenvolvimento e deploy

O Docker viabilizou o conceito Build once, run anywhere de forma prática:

    Desenvolvedores criam containers idênticos aos usados em produção.

    Reduz o clássico “na minha máquina funciona”.

    Viabiliza CI/CD moderno.

    É o motor por trás de Kubernetes (orquestração de containers).

## Atualmente: Contêineres + Orquestração

Docker sozinho é ótimo para rodar poucos containers. Mas sistemas complexos exigem:

    Escalonar centenas/milhares de containers.

    Balancear carga.

    Fazer rollouts, rollbacks e monitoramento.

    Recuperar de falhas automaticamente.

Para isso, surgiram orquestradores como:

    Kubernetes

    Docker Swarm

    OpenShift

## Resumo do progresso tecnológico

| Era                | Tecnologia   | Característica principal                                 |
| ------------------ | ------------ | -------------------------------------------------------- |
| Servidores físicos | Bare-metal   | Tudo no mesmo SO, sem isolamento                         |
| Virtualização      | Hypervisores | Múltiplos SOs isolados no mesmo hardware                 |
| Containers         | LXC, Docker  | Múltiplos apps isolados compartilhando kernel            |
| Orquestração       | Kubernetes   | Gerenciamento automatizado de containers em larga escala |

## Moral da história

Docker não substitui VMs — complementa!

VMs ainda são úteis para isolar kernels diferentes.

Containers são ótimos para isolar aplicações dentro do mesmo kernel, com startup rápido e footprint mínimo.
