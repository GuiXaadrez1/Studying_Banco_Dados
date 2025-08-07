

## Ferramentas DBA: 

PostgreSQL na versão 14 
Pgadmin
psql
codespace
docker (posteriomente)

Vscode + extensões (PostgreSql + PostgreSQL Language Server)

## Usando imagem oficial do docker para ter um servidor local Postgres
```bash
$ docker run --name connection_docker_database -e POSTGRES_PASSWORD=mysecretpassword -p 5431:5432 -d postgres

# --nome -> flag que coloca um nome para o container

# -p -> flag que mapeia a porta lógica, neste caso coloquei a porta 5431 no lugar do padrão 5432

# -d -> flag que define o banco de dados
```

## Abrindo o servidor local PostgreSql do docker

```bash
docker exec -it connection_docker_database psql -U postgres 
```
