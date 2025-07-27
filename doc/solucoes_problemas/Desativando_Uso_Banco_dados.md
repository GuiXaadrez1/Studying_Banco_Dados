# Introdução 
Este documento visa explicar como resolver o problema: 

postgres=# DROP DATABASE nome_db;
ERROR:  database "nome_db" is being accessed by other users
DETAIL:  There is 1 other session using the database.

## Por que esse erro ocorre?

No PostgreSQL, não é possível dropar (DROP DATABASE) um banco de dados que está em uso.
O PostgreSQL não permite destruir um banco se qualquer sessão estiver conectada nele, inclusive a sua sessão atual!

🔑 Mensagem de erro

```pgsql
ERROR:  database "nome_db" is being accessed by other users
DETAIL:  There is 1 other session using the database.
Significa: Existe pelo menos uma conexão ativa além da sua. Podem ser:
```
Outras sessões (psql, GUI tipo DBeaver, PgAdmin).

Sua própria conexão atual se estiver usando o mesmo banco.

## ✅ Como resolver

### Desconecte do banco

Você não pode dropar o banco estando dentro dele.

💡 Solução clássica:
Conecte-se ao banco postgres ou outro banco que não seja nome_db. Dentro do servidor local

```sql
\c postgres
```
ou no terminal:

```bash
psql -U usuario -d postgres
```

### Feche sessões de outros usuários

Use esta query para ver quem está conectado:

```sql
SELECT pid, datname, usename, application_name, client_addr
FROM pg_stat_activity
WHERE datname = 'nome_db';
```
Para forçar a desconexão de todo mundo:

```sql
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = 'nome_db';
```
⚠️ Cuidado: Isso derruba sessões ativas — use só quando for seguro.

### Agora drope
Depois que ninguém mais estiver usando, execute:

```sql
DROP DATABASE nome_db;
```