# 📚 PostgreSQL — Funções Nativas

Guia prático com as **principais funções nativas** do PostgreSQL, agrupadas por categoria, com exemplos.

---

## 🗂️ Índice

1. [Funções de Texto](#funções-de-texto)
2. [Funções Numéricas](#funções-numéricas)
3. [Funções de Data/Hora](#funções-de-datahora)
4. [Funções de Agregação](#funções-de-agregação)
5. [Funções de JSON](#funções-de-json)
6. [Funções de Sequência](#funções-de-sequência)
7. [Funções de Tipo/Conversão](#funções-de-tipoconversão)
8. [Funções de Sistema](#funções-de-sistema)
9. [Funções de Janela (Window Functions)](#funções-de-janela)

---

## 1️⃣ Funções de Texto

| Função | Descrição | Exemplo |
|--------|-----------|---------|
| `LENGTH(text)` | Tamanho da string | `SELECT LENGTH('Postgres');` → `8` |
| `LOWER(text)` | Converte para minúsculas | `SELECT LOWER('ABC');` → `abc` |
| `UPPER(text)` | Converte para maiúsculas | `SELECT UPPER('abc');` → `ABC` |
| `INITCAP(text)` | Primeira letra maiúscula | `SELECT INITCAP('postgres banco');` → `Postgres Banco` |
| `CONCAT(a,b,...)` | Junta strings | `SELECT CONCAT('Post', 'gres');` → `Postgres` |
| `SUBSTRING(text, from, for)` | Extrai substring | `SELECT SUBSTRING('Postgres', 1, 4);` → `Post` |
| `REPLACE(text, from, to)` | Substitui substring | `SELECT REPLACE('abc','b','x');` → `axc` |
| `TRIM([LEADING|TRAILING|BOTH] chars FROM text)` | Remove espaços/caracteres | `SELECT TRIM(BOTH 'x' FROM 'xxxabcxxx');` → `abc` |

---

## 2️⃣ Funções Numéricas

| Função | Descrição | Exemplo |
|--------|-----------|---------|
| `ROUND(num, dec)` | Arredonda | `SELECT ROUND(3.1415, 2);` → `3.14` |
| `CEIL(num)` ou `CEILING(num)` | Teto | `SELECT CEIL(3.2);` → `4` |
| `FLOOR(num)` | Piso | `SELECT FLOOR(3.7);` → `3` |
| `ABS(num)` | Valor absoluto | `SELECT ABS(-10);` → `10` |
| `POWER(x, y)` | Potência | `SELECT POWER(2, 3);` → `8` |
| `SQRT(num)` | Raiz quadrada | `SELECT SQRT(9);` → `3` |
| `MOD(x, y)` | Resto divisão | `SELECT MOD(10, 3);` → `1` |
| `RANDOM()` | Número aleatório [0,1) | `SELECT RANDOM();` |

---

## 3️⃣ Funções de Data/Hora

| Função | Descrição | Exemplo |
|--------|-----------|---------|
| `NOW()` | Data/hora atual | `SELECT NOW();` |
| `CURRENT_DATE` | Data atual | `SELECT CURRENT_DATE;` |
| `CURRENT_TIME` | Hora atual | `SELECT CURRENT_TIME;` |
| `EXTRACT(field FROM source)` | Extrai parte | `SELECT EXTRACT(YEAR FROM NOW());` |
| `AGE(timestamp)` | Diferença entre datas | `SELECT AGE(NOW(), '2000-01-01');` |
| `DATE_PART(field, source)` | Igual ao EXTRACT | `SELECT DATE_PART('dow', NOW());` |
| `DATE_TRUNC(field, source)` | Trunca parte | `SELECT DATE_TRUNC('month', NOW());` |

---

## 4️⃣ Funções de Agregação

| Função | Descrição | Exemplo |
|--------|-----------|---------|
| `COUNT(*)` | Conta linhas | `SELECT COUNT(*) FROM tabela;` |
| `SUM(col)` | Soma total | `SELECT SUM(valor) FROM vendas;` |
| `AVG(col)` | Média | `SELECT AVG(salario) FROM empregados;` |
| `MIN(col)` | Mínimo | `SELECT MIN(preco) FROM produtos;` |
| `MAX(col)` | Máximo | `SELECT MAX(preco) FROM produtos;` |

---

## 5️⃣ Funções de JSON

| Função | Descrição | Exemplo |
|--------|-----------|---------|
| `TO_JSON(any)` | Converte para JSON | `SELECT TO_JSON(ARRAY[1,2,3]);` |
| `ROW_TO_JSON(record)` | Registro → JSON | `SELECT ROW_TO_JSON(r) FROM (SELECT 1 as id) r;` |
| `JSON_BUILD_OBJECT` | Monta objeto JSON | `SELECT JSON_BUILD_OBJECT('id', 1, 'nome', 'João');` |
| `JSONB_SET` | Atualiza chave JSONB | `SELECT JSONB_SET('{"a":1}', '{a}', '2');` |
| `->` | Acessa chave | `SELECT '{"a":1}'::json->'a';` |
| `->>` | Acessa chave como texto | `SELECT '{"a":1}'::json->>'a';` |

---

## 6️⃣ Funções de Sequência

| Função | Descrição | Exemplo |
|--------|-----------|---------|
| `NEXTVAL('seq')` | Próximo valor | `SELECT NEXTVAL('usuarios_id_seq');` |
| `CURRVAL('seq')` | Valor atual | `SELECT CURRVAL('usuarios_id_seq');` |
| `SETVAL('seq', val)` | Define valor seq | `SELECT SETVAL('usuarios_id_seq', 100);` |

---

## 7️⃣ Funções de Tipo/Conversão

| Função | Descrição | Exemplo |
|--------|-----------|---------|
| `CAST(expr AS type)` | Converte tipo | `SELECT CAST('123' AS INTEGER);` |
| `'123'::INTEGER` | Forma curta | `SELECT '123'::INTEGER;` |

---

## 8️⃣ Funções de Sistema

| Função | Descrição | Exemplo |
|--------|-----------|---------|
| `VERSION()` | Versão do servidor | `SELECT VERSION();` |
| `CURRENT_USER` | Usuário atual | `SELECT CURRENT_USER;` |
| `SESSION_USER` | Usuário da sessão | `SELECT SESSION_USER;` |
| `PG_DATABASE_SIZE('db')` | Tamanho banco | `SELECT PG_DATABASE_SIZE('postgres');` |
| `PG_TABLE_SIZE('tbl')` | Tamanho tabela | `SELECT PG_TABLE_SIZE('usuarios');` |

---

## 9️⃣ Funções de Janela (Window Functions)

| Função | Descrição | Exemplo |
|--------|-----------|---------|
| `ROW_NUMBER()` | Numera linhas | `SELECT ROW_NUMBER() OVER (ORDER BY id) FROM tabela;` |
| `RANK()` | Rank com empates | `SELECT RANK() OVER (ORDER BY salario DESC) FROM empregados;` |
| `DENSE_RANK()` | Rank sem lacunas | `SELECT DENSE_RANK() OVER (ORDER BY nota DESC) FROM provas;` |
| `LAG()` | Valor anterior | `SELECT LAG(salario) OVER (ORDER BY data);` |
| `LEAD()` | Valor seguinte | `SELECT LEAD(salario) OVER (ORDER BY data);` |

---

## ⚙️ Observação

- Esta lista cobre **as principais** — o PostgreSQL tem **centenas**.
- Para funções matemáticas mais avançadas, veja a doc oficial: https://www.postgresql.org/docs/current/functions.html

