# Introdução 
Este documenti visa ensinar como funciona a rede e comunicação entre computadores com docker e container. Lembre-se que docker por padrão não comparilha a mesma porta lógica de acesso com o nosso host (S.O). Para é necessário realizar algumas configurações.

## Comandos introdutórios
O objetivos destes comandos não é aprender a fundo redes com container de forma inicial

Use o seguinte comando:

```bash
# -P é uma flag que permite a exposição de portas lógicas 80 ou 8080 do host com o container

docker run -P nome_user_docker_hub/nome_imagem_docker_hub

# ou 

docker run -P -d nome_user_docker_hub/nome_imagem_docker_hub

## Comando que expõem a porta lógica do docker
docker port nome_container or id_container
```

Ao usar o comando para exibir portas lógicas do container, vamos ter algo como:

```bash
80/tcp -> 0.0.0.0:32768
80/tcp -> [::]:32768
443/tcp -> 0.0.0.0:32769
443/tcp -> [::]:32769
```

Agora basta pegar a porta lógica do container e colocar na Url do navegador, exemplo:

```bash
# pegando a porta lógica http (80) como exemplo
localhost:32768
```

Agora conseguima acessar o nosso site que está no container

### Segunda forma de fazer o mapeamento de porta, compartilhamento de porta do container para o host e vice-versa:

Essa é uma forma manual, ou seja, vamos fazer o setamento, apontamento manual da porta lógica

```bash

## Podemos descobrir qual é a porta que nossa aplicação está funcionando pelo comando docker container la -a ou docker ps -a

docker container ls -a

## retorno
5fc0b84721c9   dockersamples/static-site   "/bin/sh -c 'cd /usr…"   2 minutes ago   Up 2 minutes   0.0.0.0:32768->80/tcp, [::]:32768->80/tcp, 0.0.0.0:32769->443/tcp, [::]:32769->443/tcp   gracious_chatelet

## veja que ele está fazendo apontamento: 32768->80

# Setando manualmente a porta do container, a flag -p permite isso

docker run -p num_porta:porta_lógica nome_imagem_container

## EXEMPLO MAIS COMPLETO

docker run -p 5065:80 -d dockersamples/static-site

# lembre-se que -d é uma flag que vai fazer aquele container rodar em segundo palno, para não travar o terminal

# Listando nossos container para obter informações
docker container ls -a

```

O retorno ao listar nossos container:

2af8bd5ac8f1   dockersamples/static-site   "/bin/sh -c 'cd /usr…"   36 seconds ago      Up 34 seconds                 80/tcp, 443/tcp, 0.0.0.0:5065->8080/tcp, [::]:5065->8080/tcp   hopeful_elion

veja que a porta foi mudada ao setamento manual: 0.0.0.0:5065->8080

## Explicação Aprofundada de Redes com Container