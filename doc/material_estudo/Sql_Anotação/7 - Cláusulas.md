# Introdução
Este documento visa explicar as principais cláusulas e como funciona de forma suncinta.

## O QUE SIGNIFICA CLÁSULAS EM BD

É uma parte da instrução específica que iremos utilizar naquela query para filtrarmos os dados e obter consultas mais rapidamente e especificamente! 

###  WHERE

É importante para filtrarmos os resultados e impor condições as consultas que iremos realizar! Na maioria das consultas é OBRIGATÓRIO usar o WHERE.

EXEMPLO:
```sql

    -- para atualização
    UPDATE produto SET nome_produto = ‘Feijão’ WHERE id_produto = ‘2’;

    -- para seleção e filtro
    SELECT tipoproduto FROM produtos WHERE tipoproduto = "panela";
```

### GROUP BY

Muito utilizado em consultas com a cláusula SELECT e quando queremos selecionar várias tabelas e agrupá-los em uma ou mais campos(colunas), agrega um conjunto de registros(linhas) semelhantes. A seleção fica ainda mais poderosa quando usamos funções como: SUM, COUNT, MIN, MAX e AVG.

EXEMPLO:

```sql
1-	SELECT a.nome_vendedor, COUNT(b.venda_id) AS nr_vendas, b.estado 
2-	FROM vendedores AS a INNER JOIN vendas AS b 
3-	ON a.vendedor_id = b.vendedor_id 
4-	GROUP BY b.vendedor_id, b.estado;
```

RESULTADO: Vamos ter uma tabela temporária agrupada pelo vedendor e o estado que ele pertence, contendo os dados do nome do vendedor, quantidade de produtos vendidos e o estado que ele pertence.

### ORDER BY

Utilizando essa instrução, podemos Ordenar os dados numérico de maneira crescente ASC ou decrescente DESC, já o alfabeto, ASC = ordem normal de ‘a’ até ‘z’ DESC para inverter a ordem do alfabeto, de ‘z’ até ‘a’.

EXEMPLO:
```sql
1-	SELECT DISTINCT p.emp_no, p.first_name, p.last_name, p.gender, MAX(s.salary) AS salário_máximo
2-	FROM salaries AS s INNER JOIN employees AS p ON(s.emp_no = p.emp_no) 
3-	WHERE s.salary >= 45000 AND s.salary <= 50000 GROUP BY p.emp_no ORDER BY p.emp_no ASC;
```
RESULTADO: A consulta retorna uma lista de empregados com seus respectivos números (emp_no), nomes (first_name, last_name), e gêneros (gender), juntamente com o maior salário (salário_máximo) que cada empregado recebeu dentro do intervalo de 45.000 a 50.000.
Os resultados são agrupados por número de empregado (emp_no), garantindo que cada empregado apareça apenas uma vez, mostrando o salário máximo que ele recebeu nesse intervalo. A lista é ordenada pelo número do empregado em ordem crescente.

### DISTINCT
Essa cláusula assegura os dados retornados não contenham registros duplicados, como no exemplo acima.

### UNION

Union serve para unir o resultado de duas ou mais consultas distintas em uma tabela temporária, removendo os resultados duplicado, as famosas linhas sujas ou duplicatas.

EXEMPLO: 
```sql
1-	SELECT * FROM produtos
2-	UNION
3-	SELECT * FROM funcionários;
```
### UNION ALL

Tem o mesmo funcionamento do UNION, mas este retornará dados duplicados, ocorrendo um risco de haver linhas suja.

EXEMPLO: 
```sql
4-	SELECT * FROM produtos
5-	UNION ALL
6-	SELECT * FROM funcionários;
```

### HAVING

Having é uma cláusula usada para filtrar/fazer uma triagem dos dados dos dados retornados pela cláusula Group By (usada para agrupar linhas que possuem valores iguais em colunas especificadas. É usada junto com funções de agregação (SUM(), COUNT (), AVG(), etc.) para realizar cálculos por grupo.)

Exemplo:
```sql
1-	SELECT a.nome_vendedor, COUNT(b.venda_id) AS nr_vendas, b.estado 
2-	FROM vendedores AS a INNER JOIN vendas AS b 
3-	ON a.vendedor_id = b.vendedor_id 
4-	GROUP BY b.vendedor_id, b.estado
5 – HEVING COUNT(b.venda_id) > 10000;
```

**OBSERVAÇÃO:** É possível usar o WHERE, porém deve-se ficar atento porque o WHERE é usado para filtrar linhas da tabela antes de qualquer agrupamento (GROUP BY) acontecer. GROUP BY agrupa linhas com valores iguais nas colunas indicadas. HAVING filtra os grupos formados pelo GROUP BY com base em funções de agregação. Então se formos fazer um SELECT contendo as três cláusulas, o WHERE vem antes do GROUP BY e o HAVING depois do GROUP BY

Exemplo:
```sql
1-	SELECT a.nome_vendedor, COUNT(b.venda_id) AS nr_vendas, b.estado 
2-	FROM vendedores AS a INNER JOIN vendas AS b 
3-	ON a.vendedor_id = b.vendedor_id
4-  WHERE a.vendedor ILIKE “Guilherme%” 
5-	GROUP BY b.vendedor_id, b.estado
6- HEVING COUNT(b.venda_id) > 10000;
```