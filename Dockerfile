# Criando a nossa imagem Ubuntu com curl, vim, iputis-ping, ifconfig e psql cliente

# Pegando imagem do ubuntu como base
FROM ubuntu:22.04

# Evita prompts interativos durante instalação
ENV DEBIAN_FRONTEND=noninteractive

# Declarando variáveis de ambiente padrão que podem ser sobrescritas em tempo de execução
ENV PGHOST=localhost \
    PGPORT=5432 \
    PGUSER=postgres \
    PGDATABASE=meubanco

# Executando comandos durante o build

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        vim \
        iputils-ping \
        net-tools \
        postgresql-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# \ significa quebra de linha

# Definindo um local de trabalhao
WORKDIR /database

COPY . .

EXPOSE 5432

CMD ["/bin/bash"]
## Executar o comando docker run -it --rm ubuntu-tools
## ou 
## docker run -it ubuntu-tools (mais recomendando)