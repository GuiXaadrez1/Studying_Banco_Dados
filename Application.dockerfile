# instalando node.js + distribuição alpine
FROM node:20.3.0-alpine3.18

# definindo o nosso diretório de aplicação
WORKDIR /application/src/modules/curso-docker-essencial-user-registration/user-registration

# fazenod uma argumento que capita o ip da variável de ambiente host
ARG MONGO
ENV MONGODB=$MONGO

# Informando em qual porta o node vai escutar eventos
EXPOSE 3000

# Copiando o nosso package-lock.json da máquina local (host) para o container
COPY doc/material_estudo/Docker_Estudos/exercicios/curso-docker-essencial-user-registration/user-registration/package-lock.json .

# Copiando o nosso package.json da máquina local (host) para o container
COPY doc/material_estudo/Docker_Estudos/exercicios/curso-docker-essencial-user-registration/user-registration/package.json .

# Copiando o restante do código individualmente
COPY doc/material_estudo/Docker_Estudos/exercicios/curso-docker-essencial-user-registration/user-registration/public .

COPY doc/material_estudo/Docker_Estudos/exercicios/curso-docker-essencial-user-registration/user-registration/views .

COPY doc/material_estudo/Docker_Estudos/exercicios/curso-docker-essencial-user-registration/user-registration/app.js  .

# indo para o diretório que contém o package.json
# RUN cd application/src/modules/curso-docker-essencial-user-registration/user-registration

# instalando depedências que podem ser necessárias
RUN apk add --no-cache python3 make g++

# instalando todas as libs necessárias do nosso packager json
RUN npm install

# executando no cmd
CMD ["node","app.js"]
