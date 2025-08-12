FROM mongo-express:0.54

EXPOSE 8081

# Craidno argumentos para a nossa variável de ambiente que será o ip do nosso server
ARG MONGO=$MONGOIP

# Passando argumeto para nossa variável de ambiente, o $ serve apra puxar informações em 
# argumentos e variáveis de ambiente já existentes no container

# LEMBRE-SE NÃO PODE HAVER ESPAÇO NA HORA DE DEFINIR VARIÁVEIS DE AMBIENTE
ENV ME_CONFIG_MONGODB_SERVER=$MONGO

ENV ME_CONFIG_MONGODB_PORT=27017
