# Introdução
Este documento tem como principal objetivo desmontrar como funciona o INTO no PL\PgSql

## 📌 O que significa INTO no SELECT dentro de PL/pgSQL?

Em PL/pgSQL (a linguagem procedural do PostgreSQL), o INTO é usado para capturar o resultado de uma consulta e armazenar esse resultado em variáveis locais da função ou bloco DO.

### 👉 Em outras palavras:

Fora de PL/pgSQL, SELECT retorna um result set para o cliente.

Dentro de PL/pgSQL, SELECT ... INTO joga o resultado direto para uma variável, sem mandar nada para o cliente.

## 📌 Exemplo prático

Fora de uma função (SQL puro):

```sql
SELECT nome FROM produto WHERE id = 1;
```
➡️ Isso retorna uma tabela de resultados com nome.

### Dentro de uma função PL/pgSQL:

```sql
DECLARE
  nome_produto VARCHAR(255);
BEGIN
  SELECT nome INTO nome_produto FROM produto WHERE id = 1;
END;
```

➡️ Aqui, o SELECT não devolve nada para fora. Em vez disso, o INTO armazena o valor retornado na variável nome_produto.

### 📌 Analogia simples

Fora da função: SELECT é output para o usuário.

Dentro da função: SELECT INTO é atribuição interna.

## ⚡ Resumindo

✅ INTO = Guarde o resultado aqui.

Ele substitui o := que você usaria em uma atribuição direta.
No PL/pgSQL:

```sql
-- Errado
resultado := SELECT coluna FROM tabela;

-- Certo
SELECT coluna INTO resultado FROM tabela;
```

### 🧩 Dica avançada
Se o SELECT não retorna nada, a variável recebe NULL.

Se retorna mais de uma linha, dá erro (too many rows). Para evitar isso, use LIMIT 1 ou SELECT INTO STRICT.

