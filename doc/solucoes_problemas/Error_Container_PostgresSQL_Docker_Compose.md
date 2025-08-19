# Introdução
este arquivo visa deixar resgistrado como resolver o seguinte problema:

```python
'''
Attaching to integration_test-1, postgres-1
postgres-1  | Error: Database is uninitialized and superuser password is not specified.
postgres-1  |        You must specify POSTGRES_PASSWORD to a non-empty value for the
postgres-1  |        superuser. For example, "-e POSTGRES_PASSWORD=password" on "docker run".
postgres-1  |
postgres-1  |        You may also use "POSTGRES_HOST_AUTH_METHOD=trust" to allow all
postgres-1  |        connections without a password. This is *not* recommended.
postgres-1  |
postgres-1  |        See PostgreSQL documentation about "trust":
postgres-1  |        https://www.postgresql.org/docs/current/auth-trust.html
Gracefully Stopping... press Ctrl+C again to force
dependency failed to start: container studying_banco_dados-postgres-1 is unhealthy
'''
```

## Solução

Esse erro é bem comum quando você está tentando iniciar um container do PostgreSQL via Docker sem definir a senha do superusuário (POSTGRES_PASSWORD). O PostgreSQL exige que, ao criar um container com um banco de dados não inicializado, você especifique a senha do superusuário (postgres) ou configure o método de autenticação trust (não recomendado em produção).

Você tem algumas formas de resolver:

```yaml

# definido globalmente um volume
volumes:
  pgdata:

# definindo os meus serviçõs, conjunto de containers (1 ou mais)
services:
  # nome do nosos container
  postgres:
    # imagem que ele vai usar
    image: postgres:15
    # nome container
    container_name: postgres
    # variáveis de ambiente
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: minhasenha123
      POSTGRES_DB: meu_banco
    # mapeamento de portas do host para o container
    ports:
      - "5432:5432"
    # defininfo o caminho do nosso volume
    volumes:
      - pgdata:/var/lib/postgresql/data
```

- POSTGRES_PASSWORD é obrigatório se o banco ainda não existe.
- POSTGRES_USER e POSTGRES_DB podem ser personalizados, mas o padrão postgres funciona.


### Problemas comuns

Se você já criou o volume do PostgreSQL sem senha, ele não vai aceitar a senha nova. Nesse caso, você precisa remover o volume e recriar o container:

```bash
docker-compose down -v
docker-compose up
```

O -v remove os volumes associados, permitindo que o banco seja inicializado com a nova senha.

## Resumo:

Defina POSTGRES_PASSWORD no docker-compose.yml ou no docker run.

Se estiver testando e quiser algo rápido, pode usar POSTGRES_HOST_AUTH_METHOD=trust.

Se já tentou iniciar antes sem senha, delete o volume para reiniciar a configuração.