# Contexto

Agora que vimos sobre dockerfile e como criar uma ambiente de aplicação com docker, percebemos que ao decorrer do desenvolvimento de software e solução da nossa aplicação, os container vão aumentando o número e fica praticamente inviável realizar o gerencimaento deles. Para isso, usamos o docker-compose, ele é uma ferramente que nos permite gerenciar, configurar e orquestrar vários container de uma vez.

## Exercício

Crie um docker-compose.yaml que realiza a integração entre o back-end e o banco de dados, o back-end deve ser em python e o banco de dados deve ser postgres em uma rede personalizada. Neste arquivo, deve-se definir um volume que pode ser o gerenciável pelo docker e o acesso ao banco de dados deve ser passo via variável de ambiente.