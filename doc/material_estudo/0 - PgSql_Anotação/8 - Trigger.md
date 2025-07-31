# Introdução 
Esta documentação visa ser um guia para a criação e elaboração da Trigger

## Guia Completo de Criação de Triggers no PostgreSQL

### ✅ O que é uma Trigger?

Trigger é um mecanismo de gatilho do PostgreSQL.

Permite executar uma função automaticamente em resposta a eventos DML: INSERT, UPDATE, DELETE ou TRUNCATE.

São executadas no servidor, junto com a transação.

Úteis para auditoria, restrições complexas, cálculos automáticos, replicação, logs, versionamento de dados.

função Trigger	Função especial que implementa o que deve acontecer. Deve ter RETURNS TRIGGER.

Própria Trigger	Objeto que vincula a função a uma tabela e evento.

## ⚙️ Componentes de uma Trigger

Uma trigger no PostgreSQL tem 2 peças obrigatórias:

| Peça                | Descrição                                                                        |
| ------------------- | -------------------------------------------------------------------------------- |
| **Função Trigger**  | Função especial que implementa o que deve acontecer. Deve ter `RETURNS TRIGGER`. |
| **Própria Trigger** | Objeto que **vincula** a função a uma tabela e evento.                           |

📌 Fluxo geral
```mermaid

A[Tabela com evento DML] --> B{Trigger dispara?}

B -- Sim --> C[Executa função trigger]

C --> D[Efetua ação: log, valida, bloqueia, altera]

```

## ✅ 1. Criar uma Função Trigger

```sql
CREATE OR REPLACE FUNCTION nome_funcao_trigger()
RETURNS TRIGGER
AS $$
BEGIN
  -- Lógica do que fazer
  RETURN NEW; -- ou OLD, dependendo do caso
END;
$$ LANGUAGE plpgsql;
```

### ⚠️ IMPORTANTE

NEW → representa a linha nova (em INSERT ou UPDATE).

OLD → representa a linha antiga (em UPDATE ou DELETE).

## ✅ 2. Criar a Trigger

```sql

CREATE TRIGGER nome_trigger
AFTER INSERT OR UPDATE OR DELETE -- OU BEFORE
ON tabela_alvo
FOR EACH ROW -- ou FOR EACH STATEMENT
EXECUTE FUNCTION nome_funcao_trigger();
```

## 📌 AFTER vs BEFORE
Tipo	O que significa

| Tipo           | O que significa                                                                                        |
| -------------- | ------------------------------------------------------------------------------------------------------ |
| **BEFORE**     | A trigger roda **antes** do evento ser gravado no banco. Serve para **validar** ou **alterar dados**.  |
| **AFTER**      | Roda **depois** que o evento foi concluído. Serve para **auditoria**, **logs**, **ações dependentes**. |
| **INSTEAD OF** | Para **views** — substitui a operação por outra lógica.                                                |


## ✅ 3. Exemplo Prático: Auditoria de UPDATE

📂 Tabela de log

```sql
CREATE TABLE log_produto (
  id SERIAL PRIMARY KEY,
  produto_id INT,
  antigo_preco NUMERIC,
  novo_preco NUMERIC,
  alterado_em TIMESTAMP DEFAULT now()
);

-- ⚡ Função trigger

CREATE OR REPLACE FUNCTION auditar_update_preco()
RETURNS TRIGGER
AS $$
BEGIN
  INSERT INTO log_produto (produto_id, antigo_preco, novo_preco)
  VALUES (OLD.id, OLD.preco, NEW.preco);

  RETURN NEW; -- permite o UPDATE continuar
END;
$$ LANGUAGE plpgsql;
```

## 🔑 Trigger vinculada

```sql
CREATE TRIGGER trigger_auditar_preco
AFTER UPDATE OF preco -- só para coluna preco
ON produto
FOR EACH ROW
EXECUTE FUNCTION auditar_update_preco();
```

## ⚙️ 4. Sintaxe FOR EACH ROW vs FOR EACH STATEMENT

| `FOR EACH ROW`       | Executa 1 vez **por linha afetada**                                                                             |
| -------------------- | --------------------------------------------------------------------------------------------------------------- |
| `FOR EACH STATEMENT` | Executa 1 vez **por comando** (`UPDATE produto SET ... WHERE ...`), independente de quantas linhas são afetadas |


## 5. Como Remover uma Trigger

```sql
DROP TRIGGER nome_trigger ON tabela_alvo;
```

A função trigger é separada — não é deletada junto, você precisa dar DROP FUNCTION se não for mais usada:

```sql
DROP FUNCTION nome_funcao_trigger();
```

## 🔐 6. Boas práticas

- ✅ Dê nomes claros: trigger_audit_usuario, trg_bloqueia_delete.
- ✅ Use BEFORE para bloquear/ajustar dados, AFTER para log.
- ✅ Use RAISE EXCEPTION dentro da função se quiser abortar a operação:

```sql
IF NEW.saldo < 0 THEN
  RAISE EXCEPTION 'Saldo não pode ser negativo!';
END IF;
```

✅ Use WHEN para condicionar a trigger:

```sql
CREATE TRIGGER trg_somente_preco
AFTER UPDATE OF preco
ON produto
FOR EACH ROW
WHEN (OLD.preco IS DISTINCT FROM NEW.preco)
EXECUTE FUNCTION auditar_update_preco();
```

## ⚡ 7. INSTEAD OF Trigger para VIEW
Para VIEW:

```sql
CREATE VIEW minha_view AS
SELECT * FROM produto;

CREATE OR REPLACE FUNCTION insere_view()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO produto (nome, preco) VALUES (NEW.nome, NEW.preco);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_insert_view
INSTEAD OF INSERT ON minha_view
FOR EACH ROW
EXECUTE FUNCTION insere_view();
```

🏆 Resumo Tabela
| Item            | Sintaxe                               |
| --------------- | ------------------------------------- |
| Criar função    | `CREATE FUNCTION ... RETURNS TRIGGER` |
| Criar trigger   | `CREATE TRIGGER ...`                  |
| Excluir trigger | `DROP TRIGGER nome ON tabela;`        |
| Excluir função  | `DROP FUNCTION nome();`               |
| Vincular a view | `INSTEAD OF`                          |

## 📚 Documentação oficial

PostgreSQL CREATE TRIGGER
PL/pgSQL Triggers

