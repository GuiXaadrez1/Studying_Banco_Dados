# Introdução

Um join combina registros de duas ou mais tabelas com base em uma condição de relacionamento. Joins permitem agregar informações distribuídas em tabelas diferentes, sendo fundamentais para consultas relacionais complexas.

Tipos principais de joins:

- INNER JOIN – Retorna apenas registros com correspondência em ambas as tabelas.

- LEFT JOIN (LEFT OUTER JOIN) – Retorna todos os registros da tabela da esquerda e as correspondências da direita; valores ausentes são NULL.

- RIGHT JOIN (RIGHT OUTER JOIN) – Retorna todos os registros da tabela da direita e as correspondências da esquerda; valores ausentes são NULL.

- FULL OUTER JOIN – Retorna todos os registros de ambas as tabelas; valores sem correspondência são NULL.

- CROSS JOIN – Retorna o produto cartesiano das tabelas.

## O que é o Join e para que serve os Joins?

JOINS são comandos SQL utilizados para combinar dados de duas ou mais tabelas com base em uma condição lógica de relacionamento.

Na prática, os JOINS unem registros que possuem correspondência entre tabelas, geralmente utilizando chaves primárias (Primary Key) e chaves estrangeiras (Foreign Key) — ou ainda por valores em comum entre colunas que não sejam nulos.

### Imagem ilustrativa! 

<img src="https://imgs.search.brave.com/ClFUVcEZQH0P9LYe0AKMKM5fZDHannfkL8AkDBSDkW8/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9hcnF1/aXZvLmRldm1lZGlh/LmNvbS5ici9hcnRp/Z29zL0Zlcm5hbmRh/X3NhbGxhaS9zcWxf/am9pbi9pbWFnZTAw/MS5qcGc" alt="Diagrama do Sistema">

###	A importância do produto cartesiano para ser entender Join?

O produto cartesiano entre duas tabelas significa combinar todas as linhas da primeira com todas as linhas da segunda, sem considerar nenhuma condição de junção. Isso não é muito interessante porque causa muita duplicação de registros, e retorna dados conhecidos como registros fantasmas ou registros falsos.
Matematicamente:

- Se a Tabela A tem m linhas e a Tabela B tem n linhas, o produto cartesiano terá m × n linhas

## LEFT JOIN

LEFT JOIN basicamente pega todos as linhas/registros da tabela esquerda e a interseção (registros em comum com as outras tabelas).

Exemplo sintaxe:

```sql
SELECT t1.coluna1, t2.coluna2
FROM tabela1 t1
LEFT JOIN tabela2 t2 ON t1.id = t2.id_tabela1;
```

Exmeplo prático:

```sql
SELECT c.nome AS cliente, v.id_venda, v.valor
FROM clientes c
LEFT JOIN vendas v ON c.id_cliente = v.cliente_id;
```

## RIGHT JOIN

RIGHT JOIN basicamente pega todos as linhas/registros da tabela direita e a interseção (registros em comum com as outras tabelas). É o oposto do LEFT JOIN.

Exemplo sintaxe:

```sql
SELECT t1.coluna1, t2.coluna2
FROM tabela1 t1
RIGHT JOIN tabela2 t2 ON t1.id = t2.id_tabela1;
```
Exemplo prático:

```sql
SELECT c.nome AS cliente, v.id_venda, v.valor
FROM clientes c
RIGHT JOIN vendas v ON c.id_cliente = v.cliente_id;
```

## INNER JOIN

INNER JOIN é basicamente os registros(linhas/instâncias) em comum (interseção) de todas as tabelas naquele SELECT! É proibido usar WHERE em id quando estamos usando JOINS, PORQUE: Todo Select usando WHERE com  id pk e id fk é um INNER  JOIN.

Exemplo Sintaxe:

```sql
SELECT t1.coluna1, t2.coluna2
FROM tabela1 t1
INNER JOIN tabela2 t2 ON t1.id = t2.id_tabela1;
```

Exemplo prático:

```sql
SELECT c.nome AS cliente, v.id_venda, v.valor
FROM clientes c
INNER JOIN vendas v ON c.id_cliente = v.cliente_id;
```

## FULL OUTER JOIN

FULL JOIN ou FULL OUTER JOIN é a junção de todos o os registros/linhas/instâncias de todas as tabelas presentes nesta SELECT.

Exemplo Sintaxe:

```sql
SELECT t1.coluna1, t2.coluna2
FROM tabela1 t1
FULL OUTER JOIN tabela2 t2 ON t1.id = t2.id_tabela1;
```

Exemplo prático:

```sql
SELECT c.nome AS cliente, v.id_venda, v.valor
FROM clientes c
FULL OUTER JOIN vendas v ON c.id_cliente = v.cliente_id;
```

## CROSS JOIN

O CROSS JOIN é um tipo de JOIN que retorna o produto cartesiano entre duas tabelas. Isso significa que cada linha da primeira tabela será combinada com todas as linhas da segunda tabela. Basicamente é o que vimos a respeito do produto cartesiano. MUITO POUCO UTILIZADO ESSE TIPO DE JOIN.

Exemplo Sintaxe:

```sql
SELECT t1.coluna1, t2.coluna2
FROM tabela1 t1
CROSS JOIN tabela2 t2;
```

Exemplo prático:

```sql
SELECT c.nome AS cliente, p.nome AS produto
FROM clientes c
CROSS JOIN produtos p;
```

## Boas práticas:

- Use INNER JOIN para registros correspondentes.

- Use LEFT/RIGHT/FULL OUTER JOIN para incluir registros sem correspondência.

- CROSS JOIN apenas quando realmente desejar todas as combinações possíveis.

- Prefira aliases curtos para tabelas em joins complexos.

- Combine joins com CTEs e views para maior clareza.

## Aplicações Reais 

- Relatórios que combinam clientes, vendas e produtos.

- Auditoria de dados faltantes ou inconsistentes.

- Dashboards agregando informações de múltiplas tabelas.

- Análise combinatória para recomendações ou marketing.