# Introdução ao Docker Compose

O Docker Compose é uma ferramenta que permite definir e executar múltiplos containers Docker como serviços interligados por meio de um arquivo YAML (docker-compose.yml).

Principais vantagens:

- Definição declarativa da infraestrutura do container.

- Automação de criação, start, stop, rebuild dos containers.

- Gerenciamento integrado de redes e volumes.

- Fácil escalabilidade de serviços.

## Estrutura básica do arquivo docker-compose.yml

Exemplo simplificado para os serviços MongoDB, Mongo Express e Node.js:

```yaml
version: "3.9"

services:
  mongodb:
    image: mongo:6.0
    container_name: mongodb_container
    ports:
      - "27017:27017"
    volumes:
      - mongo_data:/data/db
    networks:
      - minha_rede_app

  mongo-express:
    image: mongo-express:0.54
    container_name: mongo_express
    environment:
      ME_CONFIG_MONGODB_SERVER: mongodb_container
      ME_CONFIG_MONGODB_PORT: 27017
    ports:
      - "8081:8081"
    depends_on:
      - mongodb
    networks:
      - minha_rede_app

  node-app:
    build:
      context: ./app_node
      dockerfile: Dockerfile
    container_name: node_app
    environment:
      MONGODB: mongodb_container
    ports:
      - "3000:3000"
    depends_on:
      - mongodb
    networks:
      - minha_rede_app

networks:
  minha_rede_app:
    driver: bridge

volumes:
  mongo_data:
```

## Detalhamento das seções

### services

Define cada container como serviço:

- mongodb: usa imagem oficial, mapeia porta e volume para persistência.

- mongo-express: configuração via variáveis de ambiente, mapeia porta, depende do mongodb.

- node-app: build local da aplicação Node.js, configura variável ambiente e depende do mongodb.

### networks
Define a rede personalizada minha_rede_app com driver bridge.

### volumes
Define volume nomeado mongo_data para persistência de dados do MongoDB.

## Comandos básicos do Docker Compose

### Inicializar containers

```bash
docker-compose up -d
```

Inicia todos os serviços em background.

### Parar containers

```bash
docker-compose down
```

Para e remove containers, redes e volumes (dependendo da flag).

### Visualizar logs

```bash
docker-compose logs -f nome_servico
```

Visualiza logs em tempo real do serviço especificado.

### Build da imagem

```bash
docker-compose build
```

Reconstrói imagens configuradas para build local (ex: node-app).

## Benefícios da orquestração via Docker Compose

Define infraestrutura como código, fácil versionar e compartilhar.

Automatiza dependências entre serviços (depends_on).

Gerencia rede e volumes automaticamente.

Facilita integração contínua e entrega contínua (CI/CD).

Escala serviços com docker-compose up --scale.

## Considerações avançadas

Variáveis de ambiente podem ser definidas em arquivos .env.

Definição de healthchecks para monitoramento de containers.

Configuração de volumes externos e bind mounts.

Uso de secrets para gerenciar senhas e tokens.

## Exemplo prático: iniciando o ambiente completo

No diretório onde está o docker-compose.yml, execute:

```bash
docker-compose up -d
```

Verifique containers rodando:

```bash
docker ps
```

Teste a aplicação Node.js em http://localhost:3000, Mongo Express em http://localhost:8081.

## Resumo 

Docker Compose automatiza e simplifica a gestão de múltiplos containers e suas redes.

Arquivo YAML define serviços, redes e volumes de forma declarativa.

Configurações de dependências e variáveis de ambiente centralizam a orquestração.

Ideal para desenvolvimento, testes e implantação local e em produção.