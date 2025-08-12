# Introdução

O arquivo docker-compose.yml é um arquivo YAML que descreve a configuração de múltiplos serviços (containers), suas redes, volumes, dependências, variáveis de ambiente e outras opções.

Sua estrutura básica é:

```yaml
version: '3.9'  # Versão da sintaxe do Compose

services:       # Definição dos containers/serviços
  nome_servico:
    imagem: nginx:latest
    ports:
      - "8080:80"
    environment:
      - VAR=valor
    volumes:
      - ./app:/app

networks:       # (Opcional) Redes personalizadas
  minha_rede:

volumes:        # (Opcional) Volumes nomeados
  meu_volume:
```

## Explicando a versão

A chave version especifica a versão da sintaxe do Compose.

Recomenda-se usar a mais recente estável (como 3.9).

Versões mais antigas podem não suportar recursos atuais.

## Serviços (services)

Cada serviço representa um container Docker. Para cada serviço, é possível configurar:

- image (imagem do Docker a usar)

- build (configuração para construir imagem local)

- ports (mapear portas host:container)

- environment (variáveis de ambiente)

- volumes (montar volumes ou bind mounts)

- depends_on (ordem de inicialização)

- networks (redes a que o container estará conectado)

- restart (política de reinício)

- command (comando para rodar no container)

- healthcheck (checagem de saúde do container)

## Exmeplo de serviço com imagem
```yaml
# definfindo um serviço, container
services:
  # nome do serviço
  web:
    # imagem que será utilizada
    image: nginx:latest
    
    # mapeamento automático específico de portas do host para o container: porta_host:porta_container
    
    ports:
      - "8080:80"
```

Aqui, o serviço web usa a imagem oficial do Nginx e expõe a porta 80 do container na porta 8080 do host.

## Serviço com build local

```yaml
# definindo serviços que iram representar um container docker
services:
  # nome do serviço
  app:
    
    # faz o build da imagem local
    build:
      # indica o diretório ao qual está o nosso container
      context: ./app
      # dockerfile para gerar a imagem, se não estiver extensão .dockerfile
      # Pode se usar a forma padrão Dockerfile
      dockerfile: app.dockerfile
    ports:
      - "3000:3000"
```

**context:** indica o diretório da aplicação onde está o Dockerfile.

**dockerfile:** nome do Dockerfile (opcional se for Dockerfile).

##  Variáveis de ambiente
Variáveis de ambiente podem ser definidas em listas ou mapa:

```yaml
# lista de variáveis de ambiente
environment:
  - NODE_ENV=production
  - PORT=3000
```

```yaml
# mapa de variáveis de ambiente
environment:
  NODE_ENV: production
  PORT: 3000
```

**Lembrando que neste caso, as variáveis de ambiente podem ser declaradas no nosso arquivo.env**

## Montando volumes

Montagem de volumes para persistência ou compartilhamento:

```yaml
volumes:
  - ./data:/app/data
```

No exemplo, a pasta local ./data será acessível no container em /app/data.

## Dependências entre serviços

Controla a ordem de start dos containers:

```yaml
depends_on:
  - db
```

O serviço só iniciará depois do container db estar criado (não garante que o serviço já esteja pronto).

## Redes (networks)

Permite criar redes personalizadas.

Evita conflitos e isola ambientes.

Exmeplo:

```yaml
networks:
  minha_rede:
    driver: bridge
```

Associando rede ao serviço:

```yaml
services:
  app:
    networks:
      - minha_rede
```

## Volumes nomeados (volumes)

Volumes nomeados são gerenciados pelo Docker e independem do sistema de arquivos local.

```yaml
volumes:
  mongo_data:
```

Usando por serviço

```yaml
services:
  mongodb:
    volumes:
      - mongo_data:/data/db
```

## Outras opções importantes

restart: política de reinício automática

```yaml
restart: always
```

command: sobrescreve comando padrão

```yaml
command: ["npm", "start"]
```

healthcheck: configura testes periódicos de saúde do container

```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost"]
  interval: 30s
  timeout: 10s
  retries: 5
```

## Exemplo completo

```yaml
version: '3.9'

services:
  db:
    image: postgres:14
    environment:
      POSTGRES_PASSWORD: example
    volumes:
      - pgdata:/var/lib/postgresql/data

  backend:
    build: ./backend
    ports:
      - "5000:5000"
    depends_on:
      - db
    environment:
      DATABASE_URL: postgres://postgres:example@db:5432/postgres
    networks:
      - backendnet

networks:
  backendnet:

volumes:
  pgdata:
```

## Resumo

docker-compose.yml estrutura serviços, redes e volumes.

Serviços configuram imagens, builds, portas, variáveis, volumes, dependências.

Redes personalizadas isolam comunicação entre containers.

Volumes nomeados garantem persistência independente do host.

O arquivo é declarativo, fácil de versionar e compartilhar.