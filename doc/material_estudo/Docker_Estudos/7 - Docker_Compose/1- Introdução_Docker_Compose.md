# Introdução
Vamos aprender o básico de docker compose  afim de gerenciar, monitorar multiplos container que estão ou não em execução na nossa aplicação.

**Observação: Siga o passo a passo da instalação do plugin na documentação**

Para trabalharmos com docker compose, se estivermos já instalado o docker engine e docker cli, então será necessário instalar o plugin que se enquadra neste link:

https://docs.docker.com/compose/install/linux/#install-using-the-repository
 
## O que é Docker Compose?

O Docker Compose é uma ferramenta que permite definir e gerenciar múltiplos containers Docker como serviços interconectados usando um arquivo de configuração declarativo, geralmente em formato YAML (docker-compose.yml).

Enquanto o Docker tradicional controla containers individualmente com comandos docker run, o Compose permite orquestrar uma aplicação composta por vários containers — como bancos de dados, servidores web, caches, filas, etc — de forma simples e replicável.

## Por que usar Docker Compose?

Automatização: Com um único comando, você pode iniciar, parar, reconstruir e administrar toda a sua aplicação multi-container.

Definição declarativa: Em vez de comandos shell manuais, você descreve a arquitetura da aplicação em um arquivo legível.

Isolamento: Cada container é isolado, mas conectado via redes Docker criadas automaticamente.

Escalabilidade: É fácil criar múltiplas instâncias de um serviço para balanceamento de carga.

Portabilidade: O mesmo arquivo Compose pode ser usado em máquinas diferentes, facilitando testes, desenvolvimento e produção.

## Quando usar Docker Compose?

Desenvolvimento local de aplicações complexas.

Testes automatizados com múltiplos serviços.

Prototipagem rápida.

Pequenos ambientes de produção (em conjunto com outras ferramentas).

Ambientes onde orquestradores completos como Kubernetes seriam excessivos.

## Arquivo docker-compose.yml

É o arquivo principal onde você define:

- Serviços (containers)

- Redes (como containers se comunicam)

- Volumes (persistência de dados)

Exemplo mínimo:

```yaml
version: '3.9'

services:
  web:
    image: nginx:latest
    ports:
      - "8080:80"
```

Este exemplo define um serviço chamado web rodando a imagem oficial nginx e expondo a porta 80 do container para a porta 8080 do host.

## Comandos básicos do Docker Compose

```bash
docker-compose up # cria e inicia todos os containers.

docker-compose up -d # faz o mesmo, mas em background (detached).

docker-compose down #para e remove containers, redes, volumes e imagens criadas.

docker-compose ps # lista containers rodando.

docker-compose logs # exibe logs dos containers.

docker-compose build # força rebuild das imagens definidas com build local.
```

## Versões do arquivo Compose

Existem várias versões da sintaxe do docker-compose.yml, as mais comuns são:

Versão 2.x: mais antiga, ainda usada em projetos legados.

Versão 3.x: a mais moderna, com suporte a recursos avançados e compatibilidade com Docker Swarm.

Recomenda-se usar sempre a última versão estável, geralmente 3.9.

## Resumo

Docker Compose é uma ferramenta para orquestração simples de múltiplos containers Docker.

Arquivo docker-compose.yml define serviços, redes e volumes de forma declarativa.

Simplifica criação, execução e gerenciamento de ambientes multi-container.

Útil para desenvolvimento, testes e ambientes pequenos a médios.

Possui comandos para orquestração e monitoração dos containers.