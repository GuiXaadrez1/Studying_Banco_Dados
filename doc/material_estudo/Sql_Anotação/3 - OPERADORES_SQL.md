# Introdução 
Este documento visa ser um guia para a usuabilidade de todos os tipos de operadores dentro do sql 

## Operadores lógicos 

| Operador | Descrição                        | Exemplo SQL                         |
|----------|----------------------------------|-------------------------------------|
| `AND`    | Verdadeiro se ambas condições forem verdadeiras | `WHERE ativo = true AND idade > 18` |
| `OR`     | Verdadeiro se pelo menos uma condição for verdadeira | `WHERE cidade = 'SP' OR cidade = 'RJ'` |
| `NOT`    | Inverte o valor lógico (nega)    | `WHERE NOT ativo`                   |

## Operadores de comparação 

| Operador | Descrição                               | Exemplo SQL                          |
|----------|-----------------------------------------|--------------------------------------|
| `=`      | Igual a                                 | `WHERE nome = 'João'`                |
| `<>` ou `!=` | Diferente de                       | `WHERE status <> 'ativo'`            |
| `<`      | Menor que                               | `WHERE idade < 30`                   |
| `>`      | Maior que                               | `WHERE idade > 30`                   |
| `<=`     | Menor ou igual                          | `WHERE idade <= 30`                  |
| `>=`     | Maior ou igual                          | `WHERE idade >= 30`                  |
| `BETWEEN` | Entre um intervalo (inclusive)         | `WHERE salario BETWEEN 1000 AND 5000` |
| `LIKE`   | Compara padrão com curingas (`%`, `_`)  | `WHERE nome LIKE 'J%'`               |
| `ILIKE`  | `LIKE` sem diferença entre maiúsculas/minúsculas | `WHERE nome ILIKE 'jo%'`       |
| `IN`     | Igual a qualquer valor em uma lista     | `WHERE estado IN ('SP', 'RJ', 'MG')` |
| `IS NULL` | É nulo                                 | `WHERE data_fim IS NULL`             |
| `IS NOT NULL` | Não é nulo                         | `WHERE data_fim IS NOT NULL`         |

## Operadores Aritméticos

| Operador | Descrição               | Exemplo SQL                     |
|----------|-------------------------|---------------------------------|
| `+`      | Soma                    | `SELECT 2 + 3;`                 |
| `-`      | Subtração               | `SELECT 5 - 2;`                 |
| `*`      | Multiplicação           | `SELECT 4 * 2;`                 |
| `/`      | Divisão                 | `SELECT 10 / 2;`                |
| `%`      | Módulo (resto da divisão) | `SELECT 10 % 3;`              |
| `^`      | Potência (exponenciação) | `SELECT 2 ^ 3;`                |
| `|/`     | Raiz quadrada           | `SELECT |/ 16;`                 |
| `||/`    | Raiz cúbica             | `SELECT ||/ 27;`                |
| `@`      | Valor absoluto          | `SELECT @ -10;`                 |

## Resumo rápido 

| Categoria       | Usos                                                          |
| --------------- | ------------------------------------------------------------- |
| **Lógicos**     | Para filtrar condições compostas.                             |
| **Comparação**  | Para definir condições de igualdade, desigualdade, intervalo. |
| **Aritméticos** | Para calcular valores em SELECT, WHERE, HAVING.               |
