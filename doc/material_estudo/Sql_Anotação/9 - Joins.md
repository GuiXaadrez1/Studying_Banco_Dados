# Introdução
Este documento visa explicar suncintamente para que serve os joins no POSTGRES

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

## RIGHT JOIN

RIGHT JOIN basicamente pega todos as linhas/registros da tabela direita e a interseção (registros em comum com as outras tabelas). É o oposto do LEFT JOIN.

Exemplo sintaxe:

## INNER JOIN

INNER JOIN é basicamente os registros(linhas/instâncias) em comum (interseção) de todas as tabelas naquele SELECT! É proibido usar WHERE em id quando estamos usando JOINS, PORQUE: Todo Select usando WHERE com  id pk e id fk é um INNER  JOIN.

Exemplo Sintaxe:

## FULL OUTER JOIN

FULL JOIN ou FULL OUTER JOIN é a junção de todos o os registros/linhas/instâncias de todas as tabelas presentes nesta SELECT.

Exemplo Sintaxe:


## CROSS JOIN

O CROSS JOIN é um tipo de JOIN que retorna o produto cartesiano entre duas tabelas. Isso significa que cada linha da primeira tabela será combinada com todas as linhas da segunda tabela. Basicamente é o que vimos a respeito do produto cartesiano. MUITO POUCO UTILIZADO ESSE TIPO DE JOIN.

Exemplo Sintaxe:
