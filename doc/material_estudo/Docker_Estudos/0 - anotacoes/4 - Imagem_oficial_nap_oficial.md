# Introdução

Este documento visa explicar como funciona o pull do docker para puxar uma imagem oficial e não oficial dos responsáveis do docker

## 📦 Puxando uma imagem **oficial** do Docker

As **imagens oficiais** são mantidas e verificadas diretamente pela equipe do Docker ou por comunidades confiáveis. Elas geralmente têm **nomes simples** e **não possuem prefixo de usuário**.

- **Exemplo:**

```bash
docker pull ubuntu
```

Neste exemplo:

    O Docker entende que você está se referindo à imagem oficial library/ubuntu.

    Por padrão, ele baixa a última versão estável (geralmente :latest), a menos que você especifique outra tag.

Especificando uma versão:

```bash
docker pull python:3.12
```

Você pode listar todas as tags disponíveis de uma imagem oficial no Docker Hub, ex: 

https://hub.docker.com/search?badges=official


## puxando uma imagem não oficial, ou seja, de uma pessoa do docker hub


👤 Puxando uma imagem não oficial, ou seja, de um usuário do Docker Hub
As imagens não oficiais ou imagens personalizadas são mantidas por usuários comuns ou organizações que criam suas próprias versões de imagens.

Essas imagens possuem o nome do usuário ou da organização como prefixo.

Exemplo:

```bash
docker pull fulano123/minhaimagem
```

Neste exemplo:

    fulano123 é o nome do usuário ou organização no Docker Hub.

    minhaimagem é o nome da imagem publicada por esse usuário.

Especificando uma tag personalizada:

```bash
docker pull fulano123/minhaimagem:v1.0
```

**Atenção:** sempre verifique a confiabilidade do autor da imagem antes de usar uma imagem não oficial em ambientes sensíveis ou de produção.

## 🧠 Dica adicional

Você pode verificar se uma imagem é oficial ou não observando seu nome no Docker Hub:

Imagens oficiais: aparecem como https://hub.docker.com/_/nome-da-imagem

Imagens de usuários: aparecem como https://hub.docker.com/r/usuario/nome-da-imagem

## Resumo 

| Tipo de Imagem | Comando Exemplo                    | Observação                      |
| -------------- | ---------------------------------- | ------------------------------- |
| Oficial        | `docker pull nginx`                | Simples, sem prefixo de usuário |
| Não oficial    | `docker pull username/customimage` | Inclui o nome do usuário        |
