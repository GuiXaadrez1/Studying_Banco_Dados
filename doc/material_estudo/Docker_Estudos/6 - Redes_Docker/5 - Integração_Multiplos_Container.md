# ontexto

Nesta aplicação, temos três containers que precisam conversar entre si:

- MongoDB: banco de dados NoSQL, serviço backend.

- Mongo Express: interface web para administração do MongoDB.

- Node.js: aplicação que consome o MongoDB para lógica de negócio.

O objetivo é garantir que todos estejam conectados a uma mesma rede personalizada para:

- Comunicação via nomes de container (sem IPs fixos).

- Isolamento da rede para segurança e organização.

- Facilidade no desenvolvimento e deploy.

## Criando a rede personalizada

```bash
docker network create --driver bridge minha_rede_app
```

### Dockerfile MongoDB

```dockerfile

# Usando imagem oficial do MongoDB
FROM mongo:6.0

# Expondo porta padrão do MongoDB
EXPOSE 27017

# Persistência de dados pode ser configurada via volumes no docker run
```

### Dockerfile Mongo Express (antes e depois)

Antes — Usando IP fixo via variável de ambiente

```dockerfile

FROM mongo-express:0.54

EXPOSE 8081

ARG MONGO=$MONGOIP

ENV ME_CONFIG_MONGODB_SERVER=$MONGO
ENV ME_CONFIG_MONGODB_PORT=27017
```
Problema: O IP do MongoDB é dinâmico e pode mudar, causando falhas na conexão.

Depois — Usando nome do container para conexão

```dockerfile
FROM mongo-express:0.54

EXPOSE 8081

ENV ME_CONFIG_MONGODB_SERVER=mongodb_container
ENV ME_CONFIG_MONGODB_PORT=27017
```

### Dockerfile Node.js (antes e depois)

Antes — Passando IP como argumento

```dockerfile
FROM node:20.3.0-alpine3.18

WORKDIR /app

ARG MONGO
ENV MONGODB=$MONGO

EXPOSE 3000

COPY package*.json ./
RUN npm install

COPY . .

CMD ["node", "app.js"]
```

Depois — Usando nome do container

```dockerfile
FROM node:20.3.0-alpine3.18

WORKDIR /app

ENV MONGODB=mongodb_container

EXPOSE 3000

COPY package*.json ./
RUN npm install

COPY . .

CMD ["node", "app.js"]
```

## Executando os containers na rede personalizada

### Passo 1: Executar MongoDB com nome

```bash
docker run -dit --name mongodb_container --network minha_rede_app -p 27017:27017 mongo:6.0

# é possível colocar tag no nosso container exemplo, mongo:6.0 monog é a imagem e o nome da tag é 6.0
```
### Passo 2: Executar Mongo Express conectado à mesma rede

```bash
docker run -dit --name mongo_express --network minha_rede_app -p 8081:8081 mongo-express:0.54
```

### Passo 3: Executar aplicação Node.js conectada à rede


```bash
docker run -dit --name node_app --network minha_rede_app -p 3000:3000 minha_imagem_node
```

## Comunicação via nome de container

mongo_express acessa MongoDB usando hostname mongodb_container.

node_app acessa MongoDB usando mongodb_container.

O Docker resolve automaticamente o DNS interno da rede para esses nomes.

## Vantagens do modelo

Robustez: IPs dinâmicos não quebram a comunicação.

Escalabilidade: Adicionar múltiplos containers para cada serviço é facilitado.

Isolamento: Rede personalizada impede interferência externa.

Facilidade de manutenção: Modificar nomes e redes sem alterar código IP fixo.

## Dicas adicionais

Use volumes para persistência de dados MongoDB.

Monitorar logs com docker logs nome_container.

Use docker-compose para orquestrar essa arquitetura de forma declarativa (próximo passo de aprendizado).

## Resumo

Redes personalizadas são essenciais para integração multi-container.

Variáveis de ambiente devem referenciar nomes de container, não IPs.

Docker cria DNS interno na rede para resolução automática.

Comandos docker run --network garantem que todos containers estejam na mesma rede.

Facilita desenvolvimento, testes e deploy escalável.