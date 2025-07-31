# Introdução
Este documento serve como um guia para a criação e utilização de stored function... 
funções armazenadas dentro do Postgre com PL/PgSql.

# 📌 Guia Definitivo: Criação, Atualização e Exclusão de Funções no PL/pgSQL (PostgreSQL)

---

## O são FUNCTION no Postgre ou plpgsql? 

PostgreSQL oficialmente usa o termo “funções” (FUNCTIONS).
Tecnicamente, elas são stored functions, porque:

- São salvas (persistentes) no catálogo do banco (pg_proc).

- Podem ser chamadas a qualquer momento, por consultas ou outras funções.

- Executam dentro do servidor, sem precisar recompilar a cada chamada.

Então, na prática, as funções PL/pgSQL são stored functions — mesmo que o PostgreSQL chame simplesmente de FUNCTION.

Stored Function:

  É um objeto de banco de dados que encapsula lógica procedural, pode receber parâmetros, retornar valores e ser executado várias vezes.

## ✅ Criar Função

A sintaxe base para criar uma função é:

```sql
CREATE OR REPLACE FUNCTION nome_funcao(param1 tipo1, param2 tipo2, ...)
RETURNS tipo_de_retorno
AS $$
DECLARE
  -- Variáveis locais
  variavel tipo;
BEGIN
  -- Lógica da função
  RETURN valor;
END;
$$ LANGUAGE plpgsql;
```

### 🔍 Exemplo

```sql
CREATE OR REPLACE FUNCTION soma_dois_numeros(a INTEGER, b INTEGER)
RETURNS INTEGER
AS $$
BEGIN
  RETURN a + b;
END;
$$ LANGUAGE plpgsql;
```

### 🔄 Atualizar Função

No PostgreSQL, não existe ALTER FUNCTION para alterar o corpo.

Você substitui usando CREATE OR REPLACE FUNCTION.

### 📝 Exemplo

```sql
-- Versão original
CREATE OR REPLACE FUNCTION saudacao(nome TEXT)
RETURNS TEXT
AS $$
BEGIN
  RETURN 'Olá, ' || nome || '!';
END;
$$ LANGUAGE plpgsql;

-- Atualizando para incluir pontuação diferente
CREATE OR REPLACE FUNCTION saudacao(nome TEXT)
RETURNS TEXT
AS $$
BEGIN
  RETURN 'Oi, ' || nome || '. Bem-vindo!';
END;
$$ LANGUAGE plpgsql;
```

Dica:

- O CREATE OR REPLACE mantém mesmos parâmetros e mesmo nome.

- Para alterar assinatura (parâmetros ou tipo de retorno), DROP FUNCTION primeiro.

## ❌ Excluir Função

A sintaxe é:

```sql
DROP FUNCTION nome_funcao(param_tipo1, param_tipo2, ...);
```

**Atenção:** O PostgreSQL exige informar os tipos de parâmetros para identificar a versão correta (overload).

### 📝 Exemplo

```sql
DROP FUNCTION saudacao(TEXT);
```

### 🛡️ Boas Práticas

- ✅ Use LANGUAGE plpgsql; sempre que precisar de blocos BEGIN ... END.

- ✅ Prefira IMMUTABLE ou STABLE quando possível (para otimizar o planner):

```sql
CREATE OR REPLACE FUNCTION multiplicar(a INTEGER, b INTEGER)
RETURNS INTEGER
IMMUTABLE
AS $$
BEGIN
  RETURN a * b;
END;
$$ LANGUAGE plpgsql;
```

- ✅ Se a função modifica dados, não use IMMUTABLE.

- ✅ Use STRICT se os argumentos não podem ser NULL.

### 🧩 Exemplos úteis
Função VOID (não retorna valor)

```sql
CREATE OR REPLACE FUNCTION log_acao(msg TEXT)
RETURNS VOID
AS $$
BEGIN
  INSERT INTO logs (mensagem, data_log)
  VALUES (msg, now());
END;
$$ LANGUAGE plpgsql;
```

**Para executar:**

```sql
SELECT log_acao('Início do processamento');
-- ou
PERFORM log_acao('Ação realizada');
```

## Ver funções existentes
Para listar funções criadas no banco:

```sql
\dF  -- atalho no psql

-- Ou:

SELECT proname, proargtypes, prorettype
FROM pg_proc
WHERE proname LIKE '%nome_parcial%';
```

## Dica avançada: Procedures

Desde o PostgreSQL 11, existe PROCEDURE com CALL:

```sql
CREATE PROCEDURE exemplo_proc()
LANGUAGE plpgsql
AS $$
BEGIN
  -- Lógica
END;
$$;

CALL exemplo_proc();
Procedures permitem COMMIT/ROLLBACK internos, diferente de funções.
```

## ✅ Resumo

| 📌 **Ação**         | 📚 **Sintaxe Base**                             |
|---------------------|------------------------------------------------|
| **Criar/Atualizar** | `CREATE OR REPLACE FUNCTION ...`                |
| **Excluir**         | `DROP FUNCTION nome(param_tipo, ...)`           |
| **Executar**        | `SELECT funcao(...)` ou `PERFORM funcao(...)`   |
| **Procedure**       | `CREATE PROCEDURE ...` + `CALL nome_proc(...)`  |


## Qual a diferença entre Stored Function e Stored Procedure?
Essa é a parte que confunde muita gente — principalmente quem vem de Oracle, SQL Server ou MySQL.
|                          | **Stored Function**                            | **Stored Procedure**                                               |
| ------------------------ | ---------------------------------------------- | ------------------------------------------------------------------ |
| Retorna valor            | **Sempre retorna** um valor (mesmo que `VOID`) | Não retorna valor direto (pode retornar via `OUT` ou `INOUT`)      |
| Sintaxe                  | `CREATE FUNCTION`                              | `CREATE PROCEDURE`                                                 |
| Chamada                  | `SELECT funcao(...)` ou dentro de outro SQL    | `CALL nome_procedure(...)`                                         |
| Pode ser usada em SELECT | ✅ Sim                                          | ❌ Não                                                              |
| Transações internas      | **Não pode** `COMMIT`/`ROLLBACK` dentro        | **Pode** `COMMIT`/`ROLLBACK` dentro                                |
| Mais usada para          | Cálculos, regras de negócio reutilizáveis      | Lógicas de manutenção mais complexas, ETL, scripts administrativos |



