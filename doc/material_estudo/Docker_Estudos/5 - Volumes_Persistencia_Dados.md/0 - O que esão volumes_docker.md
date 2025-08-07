# Introdução

Por padrão, os containers do Docker são efêmeros, ou seja, todos os dados gerados ou modificados dentro de um container são perdidos quando ele é encerrado, removido ou reiniciado.

Para resolver esse problema, o Docker fornece um recurso essencial chamado Volumes, que permite a persistência de dados, ou seja, manter os dados mesmo após o container ser destruído.

## O que são Volumes?

Volumes são áreas de armazenamento gerenciadas pelo Docker no host, que podem ser montadas dentro de containers para guardar dados.

🧱 Conceito-chave:

Volumes são armazenados fora do sistema de arquivos union do container, no diretório /var/lib/docker/volumes/ do host.

Ou seja, basicamente é o armazenamaento de dados entre Docker Host e Container

### O que acontece se removermos um container sem fazer o volume?
Então, todos os dados e informações que estão naquele container são perdidos.

##  Por que usar Volumes?

Persistência de dados entre reinícios e destruição do container.

Compartilhamento de dados entre múltiplos containers.

Isolamento entre dados e código.

Melhor performance comparado a bind mounts em alguns sistemas.

Gerenciáveis pelo Docker CLI (docker volume).

Portabilidade e backup facilitados.

## 🧩 Tipos de Persistência no Docker

### Volumes

Gerenciados automaticamente pelo Docker.

Salvos em /var/lib/docker/volumes.

Podemos usar o comando inspect para poder obtermais informações do container e descobrir os caminhos de volumes no mouth:

```bash
docker inspect nome_container

# Lembre-se: podemos usar ess comando tanto para imagem qaunto para container
```

Criados com docker volume create.

Exemplo:

```bash
docker volume create novo-volume-ubuntu <nome_volume>
# obs.: volume-ubuntu é o nome da imagem
```

### Bind Mounts
Diretórios ou arquivos específicos do host montados manualmente.

Mais controle, mas menos portável.

Exemplo:

```bash
docker run  -it -v novo-volume-ubuntu:/novo  ubuntu <imagem_container>

# -v é a flag que usamos para criar um diretório onde irá ficar o nosso volume
# ele não obriga que esse diretório exista e nem o volume, você consegue criar esse volume no momento da execução.
# Logo pode usar da seguinte forma: nome_volume:diretório_volume

# ou de forma mais detalhada e segura:

docker run -it --mount source = volume-ubuntu <nome_imagem>, target = <diretório_container>  ubuntu <imagem_container> 

# Para acessar onde estão os volumes é necessário acessar como super usuário
```

### tmpfs Mounts
Armazenamento em memória (RAM), ideal para dados temporários e sensíveis.

Exemplo:

```bash
docker run --tmpfs /diretório_container nginx
```

## 📚 Como Criar e Usar Volumes

Essa é a forma mais correta de criar um volume, você pode usar o comando abaixo:

```bash
docker volume create nome-do-volume
```
Agora vocÊ pude usar o volume criado em um container:

```bash
docker run -d \
  --name meu-container \
  -v nome-do-volume:/caminho/interno \
  imagem
```

Ver volumes criados:

```bash
docker volume ls
```

Ver detalhes de um volume:

```bash
docker volume inspect nome-do-volume
```

Remover volume (após remover o container):

```bash
docker volume rm nome-do-volume
```

## 💡 Exemplo Prático com PostgreSQL

```bash

docker volume create pgdata

docker run -d \
  --name postgres-container \
  -e POSTGRES_PASSWORD=senha \
  -v pgdata:/var/lib/postgresql/data \
  -p 5432:5432 \
  postgres:14
```

Isso garante que os dados do banco serão salvos no volume pgdata, mesmo que o container seja parado ou removido.

## 🔒 Boas Práticas com Volumes

Nomeie os volumes com clareza (db_data, nginx_logs, etc.).

Evite montar volumes em diretórios que contenham código-fonte (use bind mount nesse caso).

Faça backup dos volumes regularmente usando docker cp ou docker run para criar tarballs.

Remova volumes órfãos com docker volume prune.