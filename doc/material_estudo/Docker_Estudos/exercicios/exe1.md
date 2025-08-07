# Contexto 
Esse exercício visa treinar tudo o que foi adquirido de conhecimento em relação da criação de imagens usando DockerFile e Volumes.

Você irá ficar responsável por transferir uma aplicação que estava funcionando em uma máquina virtual para um container.

## Requisistos da migração:

link: repositório para fazer o git clone: https://github.com/techeducabr/curso-docker-essencial-user-registration.git

Primeiro: Aplicação em Node JS para cadastrar usuários.

    - Irá escutar  na porta: 3000

    - Conexão com o MongoDB.

    - IP: via variável

    - Porta: literal(27017)
    
    - Base de dados: literal (mydb)

Segundo: Banco de dados MangoDB

    - Funciona na porta padrão 27017

    - Deve ter um volume /data/db

Terceiro: Mongo Express

    - Funciona na porta 8081

    - Necessita de variáveis para realizar a conexão com o MongoDB

