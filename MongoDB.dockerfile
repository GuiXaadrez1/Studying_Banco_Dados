# instalando a distribuição linux alpine 
FROM alpine:3.9

# instalando o mongo db no nosso container
RUN apk add --no-cache mongodb 

# informando a porta que o container irá executar o mongo db
EXPOSE 27017

# Criando um volume (persistência de dados, informação do container para o nosso docker host)
VOLUME /data/db

# Liberando a requisição para todas asa máquinas da rede
CMD ["mongod", "--bind_ip","0.0.0.0"]

