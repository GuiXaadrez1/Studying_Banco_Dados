# Introdução 
Este arquivo tem como principal objetivo trazer uma explicação suncinta de como funciona o nosso querido DQL, basicamente fazer tudo com ele, desde realizar buscas, buscas com filtros, selecionar funções nativas ou funções próprias que criamos (stored function), select sobre select, passar dados de uma tabela para outra e etc... Bastante utilizado.

## SELECT 

Select -> seleciona tuplas da tabela que satisfazem à condição e projeta as colunas dessas tuplas, ou seja, retorna os dados selecionados ou a informação selecionada, processada, gerada.

Sintaxe básica:

```sql
SELECT <coluna(s) tabela, pode ter apelido ou não com o ALIASE (AS)>
FROM <tabela(s),pode ter apelido ou não com o ALIASE (AS)>
WHERE <condições(ões)>
```

- WHERE é uma cláusa que requer uma condição, muito utilizado, porém podemos fazer SELECTS SEM WHARE, vai depender das cláusula que vamos utilizar...