# Introdução 
Este documento vai servir como base para cria nossa imagem par aum container docker

recomendo que leia como criar imagens no caminho: 
    
    doc\material_estudo\Docker_Estudos\0 - Anotacoes\ 1 - Como_Docker_Cria_Imagem.md

## Entendendo a criação do dockerfile

resumindo dockerfile: é uma estrutura de texto que vai conter todas as instruções para a criação de uma imagem que pode ser utilizada em um container docker.

usando o dockerfile (arq.dockerfile) é a melhor forma de criar imagens personalizadas para o nosso container. Porque não é muito pesado e sabemos exatamente os comandos que foram usados na criação da imagem utilizando:

```bash
docker history nome_imagem
```

## Como fica a estrutura de um prejeto ao criar um arquivo DockerFile e onde colocar esse arquivo DockerFile sem ser no codespace?

Resposta mais direta, na raiz do seu projeto, por padrão.

### Estrutura de projeto padrão (fora do Codespaces):

```bash
meu-projeto/
├── Dockerfile          # <- aqui está o arquivo Dockerfile
├── requirements.txt
├── app/
│   ├── __init__.py
│   └── main.py
├── .dockerignore
├── README.md
```

Pode pararecer confuso de início mas esse DockerFile é o nosso arquivo.dockerfile

Sem extensão (.txt, .docker, etc).

Com D maiúsculo (por convenção, embora minúsculo também funcione no Linux).

É um arquivo de texto puro que contém instruções para o Docker buildar uma imagem.

### Podemos criar o DockerFile como externsão de um arquivo?

Sim, tecnicamente é possível, mas exige uso explícito da flag -f no docker build.

Se você criar um arquivo chamado:

```bash
arq.dockerfile
```
Você pode usá-lo assim na hora de ciar a imagem:

```bash
docker build -f arq.dockerfile -t meu-app .
```

O -f -> docker build -f caminho/para/arquivo -t nome_da_imagem .

O -t Atribui um nome e uma tag à imagem que está sendo construída. Isso facilita identificar, executar e versionar suas imagens.

Sintaxe geral:
```bash
docker build -f caminho/para/arquivo -t nome_da_imagem .
```

### Como ficaria a estrutura dos meus projeto se eu adotasse esse modelo? 

Ficaria da seguinte forma:

```bash
meu-projeto/
├── Dockerfile.dev              # Dockerfile para ambiente de desenvolvimento
├── Dockerfile.prod             # Dockerfile otimizado para produção
├── docker-compose.yml          # Orquestra containers com base nos Dockerfiles
├── .dockerignore               # Evita enviar arquivos desnecessários pro build
├── requirements.txt            # Dependências da aplicação
├── app/                        # Código-fonte da aplicação
│   ├── __init__.py
│   └── main.py
├── tests/                      # Testes automatizados
│   └── test_main.py
└── README.md
```

Não é uma regra a sempre ser seguida colocar o DockerFile na raiz mas é interessante porque facilita de fazer o build da imagem, isto é, a criação da imagem para criarmos um container

O docker.ignore funcina da mesma forma que o gitignore, só que um é para versionamento de aplicações e o outro é para versionamento de código

Exemplo:

```bash
#docker.ignore

__pycache__/
*.pyc
*.env
*.log
tests/
.vscode/
.git/

```

## Criando na prática um DockerFile

Vamos criar um DockerFile como exemplo que pode servir como pase para criar uma imagem local que podemos criar um container local com ela.

```Dockerfile

# Usando imagem base do python
# Se você não colocar a versão após delarar :, a versão instalada é a latest
# ou seja, a versão mais recente e segura

FROM python:3.1.1 

## Define o diretório de trabalho dentro do container
##  Onde os comandos subsequentes vão rodar.
## Se o diretório não existir, ele será criado automaticamente.

WORKDIR /app

### Copia arquivos do host (máquina local) para o container.

### Aqui você está copiando o requirements.txt da raiz do projeto local para /app/requirements.txt dentro do container.

COPY requirements.txt .

#### Executa um comando durante a construção da imagem.

#### Esse comando instala as dependências listadas no requirements.txt.

### --no-cache-dir evita guardar o cache do pip dentro da imagem, tornando-a mais leve.

#### Instala as dependências do projeto
RUN pip install --no-cache-dir -r requirements.txt

######  COPY: Copia a pasta local app/ para o diretório /app/app/ dentro do container.

COPY app/ ./app

###### Comando a ser executado ao iniciar o container
CMD ["python", "app/main.py"]

```

Outro exemplo:

```Dockerfile

# Definindo uma imegm base do UBUNTU
FROM ubuntu:22.84

## executa o comando durante o build, criação da imagem no container
RUN apt-get update && \ 
    apt-get install python3.11 python3.11-dev python3-pip -y

# Definindo um diretório de trabalho para o nossa aplicação dentro do Container Docker
WORKDIR /app

# Copiando arquivos do host (máquina local) para o container.

COPY . .

# Primeiro ponto final copia tudo diretório onde contém o DockerFile e coloca dentro do container

# Segundo ponto final mas o diretório de trabalho, significa que estamos copiando tudo da máquina local para a pasta de tranalho do container

# Se estivesse que especificar o diretório, você colocaria o ./nome_diretório no segundo ou terceiro ponto final no Copy

# Executando a instalação de todas as depedência do nosso projeto 
RUN pip3 install --no-cache-dir -r requirements.txt

# OBSERVAÇÃOO NO --no-cache-dir -> Informa ao pip para não armazenar o cache dos pacotes baixados durante a instalação.

# Com --no-cache-dir instala normalmente os pacotes
#Não armazena o cache localmente
#Libera espaço no container Docker após a instalação

# Colocar o container para executar na porta lógica 8080
EXPOSE 8080

# Declarando variáveis de ambiente do nosso projeto dentro do DockerFile!
ENV LOGOMARCA = "https://www.freepik.com/photos/logo"
ENV EMAIL = "guix1delas@gmai.com.br"

# Executa comandos ao iniciar o container
CMD ['python3','app.py']

# dentro de /app -> python3 app.py

# AGORA O BUILD DA IMAGEM VAI SER NO DIRETÓRIO ONDE O NOSSO DOCKERFILE ESTÁ
```

```bash

# comando para builda a nossa imagem para arquivos sem a extensão .dockerfile apenas com o nome normal DockerFile

docker build -t nome_da_imagem .

# comando para builda a nossa imagem para arquivos com extensão .dockerfile
docker build -f caminho/para/arquivo -t nome_da_imagem .
```

**OBSRVAÇÕES:** 

- O comando EXPOSE não mapeia portas automaticamente.

- Ele apenas documenta para o Docker e para quem lê o Dockerfile que a aplicação escuta naquela porta.

- O mapeamento real é feito no docker run -p ou no docker-compose.yml.

### Resumo de cada elemento no DockerFile

| Elemento  | Explicação curta                                                                                     |
| --------- | ---------------------------------------------------------------------------------------------------- |
| `FROM`    | Define a imagem base que será usada (ex.: `python:3.11-slim`, `node:20-alpine`)                      |
| `WORKDIR` | Define o diretório de trabalho dentro do container onde comandos serão executados                    |
| `COPY`    | Copia arquivos ou pastas do **host** para o sistema de arquivos do container                         |
| `RUN`     | Executa comandos durante o **build** da imagem (instala pacotes, cria pastas, etc.)                  |
| `CMD`     | Comando padrão executado ao **iniciar** o container (pode ser sobrescrito pelo `docker run`)         |
| `EXPOSE`  | **Documenta** a porta que o container escuta (não faz o mapeamento, apenas registra no metadado)     |
| `ENV`     | Define variáveis de ambiente no container, usadas pela aplicação                                     |
| `ARG`     | Define variáveis de **build-time** (disponíveis apenas durante o build, não no runtime como o `ENV`) |


### Posso colocar Python e PostgreSQL juntos em um único Dockerfile?

Você não deve colocar PostgreSQL dentro do mesmo Dockerfile da aplicação Python.

Por quê? 

| Motivo técnico                                                   | Explicação                                                                                                                                  |
| ---------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| **Imagens monolíticas** são contra a filosofia Docker            | Cada imagem deve ter **um único propósito/responsabilidade**                                                                                |
| Complicação no processo de build                                 | Ter dois serviços (Postgres e Python) no mesmo container exige instalar, configurar, e gerenciar dois processos distintos no mesmo ambiente |
| Problemas de escalabilidade e manutenção                         | Você não pode reiniciar o banco ou o app separadamente                                                                                      |
| A própria **Docker Inc.** recomenda **um container por serviço** | Isso facilita orquestração, logs, rede, isolamento, CI/CD etc.                                                                              |


### 📉 O que aconteceria se você tentasse?

Você teria que:

- Instalar o PostgreSQL manualmente com apt install postgresql no Dockerfile

- Rodar dois processos dentro do mesmo container (Python + PostgreSQL)

- Isso quebra o padrão do Docker

- Você precisaria usar supervisord, bash scripts, ou outras soluções sujas para manter os dois processos rodando

- Lidar com mais camadas, conflitos de porta, logs e manutenção

### Forma correta:

| Serviço    | Imagem base        | Dockerfile necessário?    |
| ---------- | ------------------ | ------------------------- |
| Python App | `python:3.11-slim` | ✅ Sim                     |
| PostgreSQL | `postgres:14`      | ❌ Não (usa imagem pronta) |

Use o Dockerfile apenas para a sua aplicação.

Use o docker-compose.yml para juntar a aplicação com o banco.

## O que é o docker-compose?

docker-compose é uma ferramenta de orquestração de containers Docker que permite definir, configurar e subir múltiplos containers de uma vez só, usando um arquivo YAML (geralmente chamado docker-compose.yml).

Sem o Compose, você precisa executar vários comandos docker run separados, com várias opções de porta, volume, rede, etc.

Com docker-compose, você:

- Organiza tudo num único arquivo (docker-compose.yml)

- Sobe tudo com um único comando: docker-compose up

- Facilita o uso de ambientes como: app + banco + redis + nginx

### Exemplo prático: Python + PostgreSQL

Estrutura:

```bash
meu-projeto/
├── docker-compose.yml
├── Dockerfile
├── app/
│   └── main.py
├── requirements.txt
📄 docker-compose.yml
```

```yaml
version: "3.8"

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "8000:8000"
    volumes:
      - .:/app
    depends_on:
      - db

  db:
    image: postgres:14
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: meu_banco
    ports:
      - "5432:5432"
```

Veja que ele tem um funcionamente bem parecido com o GitHub Action e a extensão do arquivo é o mesmo .yml ou .yaml porém para objetivos distintos. 

Subindo tudo de uma vez:

```bash
docker-compose up
```

### O que o Compose gerencia?

| Recurso         | O que faz                                       |
| --------------- | ----------------------------------------------- |
| **services**    | Define os containers que serão criados          |
| **build**       | Define o contexto e Dockerfile para o serviço   |
| **image**       | Usa uma imagem Docker (ex: postgres)            |
| **ports**       | Mapeia portas do host para o container          |
| **volumes**     | Mapeia arquivos/pastas locais com os containers |
| **environment** | Passa variáveis de ambiente                     |
| **depends\_on** | Define ordem de dependência entre containers    |


### Comandos úteis com docker-compose

```bash
docker-compose up           # Sobe os containers
docker-compose down         # Derruba todos os containers e redes criadas
docker-compose build        # Faz o build de todas as imagens
docker-compose ps           # Lista os containers em execução
docker-compose logs         # Mostra os logs
docker-compose exec app sh  # Executa um shell dentro do container 'app'
```

### Vantagens do Docker Compose

| Sem Compose                     | Com Compose                            |
| ------------------------------- | -------------------------------------- |
| `docker run` longo e repetitivo | Tudo em um `docker-compose.yml`        |
| Difícil gerenciar dependências  | `depends_on` lida com a ordem certa    |
| Múltiplos terminais abertos     | Um comando sobe tudo                   |
| Dificuldade em produção/dev     | Possibilidade de usar múltiplos perfis |

### 🔥 Resumo

docker-compose é a forma profissional de orquestrar múltiplos containers.

Usa o arquivo docker-compose.yml para declarar serviços, imagens, volumes, redes e variáveis.

Ideal para projetos fullstack, APIs com banco, filas, workers, testes, etc.

Torna seu ambiente reproduzível, automatizado e escalável.
