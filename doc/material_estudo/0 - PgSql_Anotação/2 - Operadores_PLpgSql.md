# Introdução
O objetivo aqui é aprender os operadores de atribuição, comparação e metemático

## 📂 1️⃣ Operadores de Atribuição — PL/pgSQL
No PostgreSQL SQL padrão não tem operador de atribuição porque você faz INSERT, UPDATE etc.
Atribuição existe dentro do bloco PL/pgSQL, via := ou SELECT INTO.

## 📝 Operadores de Atribuição (PL/pgSQL)

| Operador | Descrição | Exemplo |
|----------|-----------|---------|
| `:=` | Atribui um valor a uma variável | `meu_num := 10;` |
| `SELECT INTO` | Atribui o resultado de uma query a uma variável | `SELECT nome INTO var_nome FROM cliente WHERE id = 1;` |
| `PERFORM` | Executa uma query que não retorna nada | `PERFORM atualiza_dados();` |

### 🔑 Resumo

:= é o operador de atribuição interno.

= é só para comparação em expressões lógicas.

SELECT INTO é a forma mais comum de capturar resultados de SELECT.

## 🔍 Operadores de Comparação (SQL)
PostgreSQL segue SQL padrão, os operadores são iguais ao ANSI SQL.

| Operador | Descrição | Exemplo |
|----------|-------------------------|----------------|
| `=` | Igual | `WHERE idade = 18` |
| `<>` ou `!=` | Diferente | `WHERE nome <> 'Maria'` |
| `<` | Menor que | `WHERE preco < 100` |
| `>` | Maior que | `WHERE data > '2024-01-01'` |
| `<=` | Menor ou igual | `WHERE quantidade <= 10` |
| `>=` | Maior ou igual | `WHERE nota >= 7` |
| `IS NULL` | É nulo | `WHERE data_entrega IS NULL` |
| `IS NOT NULL` | Não é nulo | `WHERE email IS NOT NULL` |
| `BETWEEN` | Entre | `WHERE salario BETWEEN 1000 AND 3000` |
| `LIKE` | Corresponde padrão | `WHERE nome LIKE 'Jo%'` |
| `ILIKE` | Corresponde padrão sem case sensitive | `WHERE nome ILIKE 'jo%'` |
| `IN` | Está na lista | `WHERE estado IN ('SP', 'RJ')` |

## Operadores Matemáticos
PostgreSQL tem operadores aritméticos padrão, mais funções matemáticas poderosas.

## ➗ Operadores Matemáticos (SQL)

| Operador | Descrição | Exemplo | Resultado |
|----------|----------------|----------------|----------------|
| `+` | Soma | `SELECT 2 + 3;` | `5` |
| `-` | Subtração | `SELECT 10 - 4;` | `6` |
| `*` | Multiplicação | `SELECT 2 * 5;` | `10` |
| `/` | Divisão | `SELECT 10 / 2;` | `5` |
| `%` | Módulo (resto) | `SELECT 10 % 3;` | `1` |
| `^` | Potência | `SELECT 2 ^ 3;` | `8` |
| `|/` | Raiz quadrada | `SELECT |/ 9;` | `3` |
| `||/` | Raiz cúbica | `SELECT ||/ 27;` | `3` |
| `@` | Valor absoluto | `SELECT @ -15;` | `15` |

## Dica extra
Para operações mais complexas, use funções matemáticas embutidas:

```sql
SELECT round(10.75);  -- Arredonda para 11
SELECT ceil(10.2);    -- Arredonda para cima: 11
SELECT floor(10.9);   -- Arredonda para baixo: 10
SELECT sqrt(25);      -- Raiz quadrada: 5
SELECT exp(1);        -- Exponencial: e^1
SELECT ln(10);        -- Logaritmo natural
```

## Resumo Geral

| Categoria   | Símbolo principal       | Contexto                    |
| ----------- | ----------------------- | --------------------------- |
| Atribuição  | `:=`                    | PL/pgSQL (blocos BEGIN/END) |
| Comparação  | `=`, `<>`, `LIKE`       | SQL (WHERE)                 |
| Matemáticos | `+`, `-`, `*`, `/`, `%` | SQL (SELECT)                |
