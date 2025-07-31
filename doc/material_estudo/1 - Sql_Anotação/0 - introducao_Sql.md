# Introducao
Vamos aprender todos os fundamentos básicos de SQL e teoricos da linguagem do SQL

## SQL

SQL significa: Structured Query Languagem

- Linguagem padrão para se trabalhar com bases de dados relacionais

- Linguagem inspirada nos conceitos de álgebra relacional e de operações com conjuntos
(interessante aprender álgebra linear, relacional e conjunções para pleno entendimento matemático.)

- É uma linguagem declarativa e não procedural

- PL-SQL: atribui algumas características procedurais à linguagem Sql, com isso temos o nosso PL\PgSql.

- fácil de aprender (em geral)

- rápida, gera pouco código é potável. (LAPTOP, PC, Servidores e dispositivos móveis)

- possui um padrão internacionalmente consolidado (ISO e ANSI)

## Utilidades 

- Executar busca dos dados (com index fica ainda mais rápido)

- Descrever domínios dos dados ( tipos de dados )

- Manipular dados

- Remover tabelas 

- Remover bases de dados (bancos de dados)

- Criar visões 

- Criar permissões

## sub-divisões da lingugaem sql:

- DDL (Data Definition Language)

- DML (Data Manipulation Language)

- DQL (Data Query Language)

- TCL (Transactional Control Language)

- DCL (Data Control Language)

## introdução ao DDL ( DATA DEFINITION LANGUAGE)

Utilizados para lidar com os objetos da base de dados, isto é, a criação, definição, regras de como a estrutura daquela banco de dados desde o banco (propriamente dito) + schema (uma espécie de subdivisão do banco) até as definições das tabela com suas restrições ou não e as alterações da mesma, o DDL não lida com os dados em si, que faz isso é o DML ( DATA MANIPULATION LANGUAGE ).

**Principais comando:**

- CREATE -> criar objetos, instância, schema dentro do nosso SGBD

- ALTER -> faz alterações dos objetos, instâncias, schemas 

- DROP -> deleta físicamente esses objetos, instância e schema

## introdução ao DML (DATA MANIPULATION LANGUAGE)

Essa é a sub-divisão da Structured Query Languagem que interage ativamente com os dados armazenados, registrados nas tabelas do nosso banco de dados.

**Principais comandos:**

- INSERT -> insere um registro, tupla nas tabelas (entidades, arquivos) do nosso "database"

- UPDATE -> faz as atualizações dos registros, tuplas 

- DELETE -> faz o delete físico destes registros, tuplas

- Alguns autores incluem o SELECT como DML outros discordam e colocam como DQL

--- 

## Diagrama

<img src="https://imgs.search.brave.com/vMTasdhswmoaNc09vTwE7m06GTvzB4DP6GGTREjvvwg/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9jZG4u/YW5hbHl0aWNzdmlk/aHlhLmNvbS93cC1j/b250ZW50L3VwbG9h/ZHMvMjAyMi8wNS80/MTQ1OHNxbGxsLTY3/NDZmZGE1YzEyNTku/d2VicA" alt="Diagrama do Sistema">

---


