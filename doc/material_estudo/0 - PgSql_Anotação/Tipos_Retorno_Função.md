# Introdução 
Este arquivo visa explicar como funciona os tipos de retornos das funções (stored function) que criamos com plpgsql.

## Tabela dos tipos de retornos(RETURNS)

| Tipo de Retorno | Descrição | Quando usar | Exemplo |
|-----------------|--------------------------------|-------------------------------|-----------------------------|
| `RETURNS tipo_escalar` | Retorna **um único valor escalar** (INT, TEXT, NUMERIC, BOOLEAN, DATE, etc). | Cálculos simples, status, checagem. | `RETURNS INT`<br>`RETURN 42;` |
| `RETURNS VOID` | Não retorna valor. Só **executa lógica** (ex: logs, inserts). | Quando a função **faz algo**, mas não devolve resultado. | `RETURNS VOID`<br>`PERFORM minha_funcao();` |
| `RETURNS RECORD` | Retorna **uma linha genérica**, tipo `ROW`. Você **define os campos na hora da consulta**. | Queries dinâmicas, retornos flexíveis, quando os tipos variam. | `RETURNS RECORD`<br>`RETURN QUERY SELECT ...;` |
| `RETURNS TABLE (...)` | Retorna uma **tabela virtual**: várias colunas, várias linhas. | APIs SQL, views materializadas, pipelines de dados. | `RETURNS TABLE (id INT, nome TEXT)`<br>`RETURN QUERY SELECT ...;` |
| `RETURNS SETOF tipo` | Retorna **várias linhas** de **um tipo específico** (ex: linha de uma tabela, ou tipo escalar). | Listar resultados, streams de dados. | `RETURNS SETOF produto`<br>`RETURN QUERY SELECT * FROM produto;` |
| `RETURNS SETOF RECORD` | Igual ao `SETOF tipo`, mas **dinâmico**. A estrutura é definida na hora da chamada. | Queries multi-row sem tipo fixo, SQL dinâmico. | `RETURNS SETOF RECORD`<br>`RETURN QUERY SELECT * FROM ...;` |
| `RETURNS JSON` ou `JSONB` | Retorna um **bloco JSON estruturado** (objeto ou array). | Para APIs REST, integração externa, serialização complexa. | `RETURNS JSON`<br>`RETURN json_build_object(...);` |
| `RETURNS tipo[]` (Array) | Retorna um **array PostgreSQL** (ex: INT[], TEXT[]). | Para listas compactas: IDs, nomes, etc. | `RETURNS TEXT[]`<br>`RETURN ARRAY['a', 'b', 'c'];` |
| `RETURNS DOMAIN` | Retorna um **tipo de domínio** definido por restrições personalizadas. | Validação restrita. | `RETURNS meu_dominio`<br>`RETURN valor;` |
| `RETURNS ENUM` | Retorna um **valor de tipo ENUM** definido pelo usuário. | Situações onde um campo aceita apenas valores limitados. | `RETURNS meu_enum`<br>`RETURN 'VALOR1';` |
| `RETURNS TRIGGER` | Usado em **funções de gatilho** (trigger). Executa automaticamente em eventos DML. | Auditoria, validação, controle de alterações. | `RETURNS TRIGGER`<br>`RETURN NEW;` |

## Exemplos práticos comentádos e explicados!

### RETURNS tipo_escalar

```sql
-- Função simples que soma dois números inteiros
CREATE OR REPLACE FUNCTION soma(a INT, b INT) RETURNS INT 
AS $$
    BEGIN
    -- Retorna um único valor escalar (INT)
    RETURN a + b;
    END;
$$ 
LANGUAGE plpgsql;

-- Teste
SELECT soma(10, 20); -- Resultado: 30
```
**Usar quando:** precisa de resultado único, direto, numérico, textual, etc.

### RETURNS VOID
```sql
-- Função que apenas insere um log, não devolve valor
CREATE OR REPLACE FUNCTION log_evento(msg TEXT) RETURNS VOID 
AS $$
    BEGIN
      INSERT INTO logs (mensagem, data_criacao) VALUES (msg, now());
    END;
$$ 
LANGUAGE plpgsql;

-- Teste: chamada usando PERFORM (ignora retorno)
PERFORM log_evento('Usuário logou');
```
**Usar quando:** a função faz efeitos colaterais e não devolve dados, porém na tabela as mudanças aconteceram, é interessante colocar um RAISE NOTICE para aparecer uma mensagem no menssagem no SGBD PgAdmin.

### RETURNS RECORD

```sql
-- Função dinâmica: retorna uma linha genérica (id, nome)
CREATE OR REPLACE FUNCTION busca_record(prod_id INT) RETURNS RECORD 
AS $$
    DECLARE
        resultado RECORD;
    BEGIN
        SELECT id, nome INTO resultado FROM produto WHERE id = prod_id;
    RETURN resultado;
    END;
$$ 
LANGUAGE plpgsql;

-- Teste: precisa declarar colunas
SELECT * FROM busca_record(1) AS t(id INT, nome TEXT);
```
**Usar quando:** precisa retornar linha com estrutura dinâmica.

### RETURNS TABLE (...)

```sql
-- Retorna várias linhas e colunas em formato de tabela
CREATE OR REPLACE FUNCTION lista_produtos(min_preco NUMERIC) RETURNS TABLE (id INT, nome TEXT, preco NUMERIC) 
AS $$
    BEGIN
        RETURN QUERY
        SELECT id, nome, preco FROM produto WHERE preco >= min_preco;
    END;
$$ 
LANGUAGE plpgsql;

-- Teste
SELECT * FROM lista_produtos(100);
```

**Usar quando:** função age como view parametrizada

### RETURNS SETOF tipo

```sql
-- Retorna várias linhas de uma tabela inteira
CREATE OR REPLACE FUNCTION lista_ids() RETURNS SETOF INT 
AS $$
    BEGIN
        RETURN QUERY SELECT id FROM produto;
    END;
$$ 
LANGUAGE plpgsql;

-- Teste
SELECT * FROM lista_ids();
```
**Usar quando:** quer devolver várias linhas de mesmo tipo.

#### : O que é RETURN QUERY?
- É uma instrução especial dentro de uma função plpgsql do tipo RETURNS SETOF ou RETURNS TABLE.

- Serve para retornar múltiplas linhas de uma consulta SELECT dentro da função.

É diferente de RETURN normal:

    RETURN → finaliza a função imediatamente, retornando um único valor.

    RETURN QUERY → anexa os resultados de uma SELECT ao conjunto final de saída.

O RETURN QUERY não executa nada sozinho — ele precisa de uma SELECT ou EXECUTE logo em seguida.

### RETURNS SETOF RECORD

```sql
-- Retorna várias linhas, mas tipo é definido na consulta
CREATE OR REPLACE FUNCTION busca_dinamica(tabela TEXT) RETURNS SETOF RECORD 
AS $$
    BEGIN
        RETURN QUERY EXECUTE format('SELECT * FROM %I', tabela);
    END;
$$ 
LANGUAGE plpgsql;

-- Teste: informe colunas
SELECT * FROM busca_dinamica('produto') AS t(id INT, nome TEXT, preco NUMERIC);
```

**Usar quando:** precisa de multi-row com estrutura variável.

### RETURNS JSON

```sql
-- Retorna todos produtos como JSON
CREATE OR REPLACE FUNCTION produtos_json() RETURNS JSON 
AS $$
    DECLARE
        resultado JSON;
    BEGIN
        SELECT json_agg(p) INTO resultado FROM produto p;
        RETURN resultado;
    END;
$$ 
LANGUAGE plpgsql;

-- Teste
SELECT produtos_json();
```
Usar quando: API REST ou serialização.

### RETURNS tipo[] (Array)

```sql
-- Retorna lista de nomes como array de texto
CREATE OR REPLACE FUNCTION nomes_array() RETURNS TEXT[] 
AS $$
    DECLARE
        resultado TEXT[];
    BEGIN
        SELECT array_agg(nome) INTO resultado FROM produto;
        RETURN resultado;
    END;
$$ 
LANGUAGE plpgsql;

-- Teste
SELECT nomes_array();
```

**Usar quando:** lista compacta de strings, IDs, flags.

### RETURNS DOMAIN
```sql

-- Cria domínio (ex: email válido)
CREATE DOMAIN email_valido AS TEXT CHECK (
  VALUE ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+$'
  -- validando com o nosso querido REGEX1
);

-- Função que retorna tipo DOMAIN
CREATE OR REPLACE FUNCTION validar_email(email TEXT) RETURNS email_valido 
AS $$
    BEGIN
        RETURN email; -- O PostgreSQL verifica restrição
    END;
$$ 
LANGUAGE plpgsql;

-- Teste
SELECT validar_email('exemplo@dominio.com');
```
**Usar quando:** precisa validar regras adicionais com tipos customizados.

### RETURNS ENUM
```sql
-- Cria tipo ENUM
CREATE TYPE status_pedido AS ENUM ('PENDENTE', 'PAGO', 'CANCELADO');

-- Função que retorna ENUM
CREATE OR REPLACE FUNCTION status_padrao() RETURNS status_pedido
AS $$
    BEGIN
      RETURN 'PENDENTE';
    END;
$$ 
LANGUAGE plpgsql;

-- Teste
SELECT status_padrao()
```

**Usar quando:** valor precisa ser restrito a opções fixas.

### RETURNS TRIGGER
```sql
-- Função especial de gatilho
CREATE OR REPLACE FUNCTION auditar_update() RETURNS TRIGGER 
AS $$
    BEGIN
        INSERT INTO logs (mensagem, data_criacao)
            VALUES ('Linha modificada', now());
            RETURN NEW; -- Mantém a linha
    END;
$$ 
LANGUAGE plpgsql;

-- Cria trigger vinculando a função
CREATE TRIGGER trg_audit AFTER UPDATE ON produto
    FOR EACH ROW
        EXECUTE FUNCTION auditar_update();
```

**Usar quando:** quer automatizar ação em evento INSERT, UPDATE, DELETE.