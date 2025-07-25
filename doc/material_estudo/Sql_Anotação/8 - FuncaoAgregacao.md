# Introdução
Este documento visa explicar suncintamente para que serve a função de agregação e como funciona

## O que é e para que serve?

Funções de agregação no SQL servem para resumir ou consolidar dados de múltiplas linhas em um único valor. Elas são amplamente utilizadas em consultas que envolvem agrupamentos (GROUP BY) ou análises estatísticas.

## Max

Retorna a maior quantidade dos registros. Ou seja, o valor máximo.

Exemplo:
```sql
1-	SELECT a.nome_vendedor, MAX(b.venda) AS vl_max_vendas, b.estado 
2-	FROM vendedores AS a INNER JOIN vendas AS b 
3-	ON a.vendedor_id = b.vendedor_id
4-	-  WHERE a.vendedor ILIKE “Guilherme%” 
5-	GROUP BY b.vendedor_id, b.estado;
```

## Min

Retorna a menor quantidade dos registros. Ou seja, o valor mínimo.

Exemplo:
```sql
1-	SELECT a.nome_vendedor, MIN(b.venda) AS vl_min_vendas, b.estado 
2-	FROM vendedores AS a INNER JOIN vendas AS b 
3-	ON a.vendedor_id = b.vendedor_id
4-	-  WHERE a.vendedor ILIKE “Guilherme%” 
5-	GROUP BY b.vendedor_id, b.estado;
```

## Sum
Retorna o somatório dos registros. Ou seja, o valor de uma linha somada ao valor de outra linha e posteriormente até retorna o valor total deste somatório.

Exemplo:
```sql
1-	SELECT a.nome_vendedor, SUM(b.vendas) AS soma_vendas, b.estado 
2-	FROM vendedores AS a INNER JOIN vendas AS b 
3-	ON a.vendedor_id = b.vendedor_id
4-	-  WHERE a.vendedor ILIKE “Guilherme%” 
5-	GROUP BY b.vendedor_id, b.estado;
```

## Count

Retorna a quantidade de registros presentes naquela tabela. Ou seja, se temos 30 registros, ele irá retornar os 30 registros.

Exemplo:
```sql
1-	SELECT a.nome_vendedor, COUNT(b.venda_id) AS nr_vendas, b.estado 
2-	FROM vendedores AS a INNER JOIN vendas AS b 
3-	ON a.vendedor_id = b.vendedor_id
4-	-  WHERE a.vendedor ILIKE “Guilherme%” 
5-	GROUP BY b.vendedor_id, b.estado;
```

## AVG

Retorna a média aritmética dos registros presentes naquela tabela.

Exemplo:
```sql
1-	SELECT a.nome_vendedor, AVG(total_vendas) AS md_vendas, b.estado
2-	FROM (
3-	SELECT a.vendedor_id, b.estado, SUM(b.venda) AS total_vendas
4-	FROM vendedores AS a
5-	INNER JOIN vendas AS b ON a.vendedor_id = b.vendedor_id
6-	WHERE a.vendedor ILIKE 'Guilherme%'
7-	GROUP BY a.vendedor_id, b.estado
8-	) AS subquery
9-	GROUP BY nome_vendedor, estado;
```