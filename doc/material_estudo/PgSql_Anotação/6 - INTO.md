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

## INTO para múltiplas variáveis

o PL/pgSQL, quando seu SELECT retorna mais de uma coluna, você pode capturar cada coluna em uma variável local diferente — tudo no mesmo INTO.

Sintaxe geral:
```sql
SELECT coluna1, coluna2, coluna3
INTO var1, var2, var3
FROM tabela
WHERE ...;
```

### Exemplo prático:

```sql
CREATE OR REPLACE FUNCTION info_produto(produto_id INT)
RETURNS TEXT
AS $$
DECLARE
  v_nome VARCHAR(100);
  v_preco NUMERIC;
  v_qtd INTEGER;
BEGIN
  SELECT nome, preco, qtd
  INTO v_nome, v_preco, v_qtd
  FROM produto
  WHERE id = produto_id;

  RETURN format('Produto: %s | Preço: %.2f | Qtd: %s', v_nome, v_preco, v_qtd);
END;
$$ LANGUAGE plpgsql;
```

**Observações:**

No PostgreSQL, format() é uma função nativa que monta strings formatadas, semelhante ao printf de C ou sprintf de muitas linguagens.

```sql
format('texto %s', valor);
```

➡️ O que isso faz:

1️⃣ 'Produto: %s ...' → %s é substituído pelo v_nome (string).
2️⃣ 'Preço: %.2f ...' → %.2f mostra v_preco como número de ponto flutuante com 2 casas decimais (ex: 19.99).
3️⃣ 'Qtd: %s' → %s de novo para v_qtd. Mesmo que v_qtd seja INTEGER, o %s converte implicitamente pra texto.

O format substitui marcadores de posição (%s, %.2f, %I, %L...) pelos valores que você passa na ordem.

### Explicando os marcadores

| **Marcador** | O que significa                                     |
| ------------ | --------------------------------------------------- |
| `%s`         | String genérica (valor tratado como texto)          |
| `%I`         | Identificador SQL (escapa nomes de colunas/tabelas) |
| `%L`         | Literal SQL (escapa strings com aspas)              |
| `%f`         | Número em ponto flutuante                           |
| `%.2f`       | Número em ponto flutuante com 2 casas decimais      |

###  Regra importante

O número de variáveis no INTO deve bater com o número de colunas retornadas.

Se não bater, o PostgreSQL retorna erro de “wrong number of variables”.

## Também funciona com JOIN

Exemplo:
```sql
SELECT a.col1, b.col2
INTO var1, var2
FROM tabela1 a
JOIN tabela2 b ON ...
WHERE ...;

```

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

