# Introdução
Este documento tem como principal anotar, revisar DML

## Comando INSERT! 
O comando INSERT são usados para inserir, preencher: campos, domínios, atributos que são definidos na hora da criação das tabelas do nosso bacanco de dados, abaixo vai um exemplo da sintaxe:

```sql
-- forma recomendada!
INSERT INTO <nome_tabela> (col1,col2,col3)
VALUES(valor_col1,valor_col2,valor_col3); 

-- ou

INSERT INTO <nome_tabela> VALUES(valor_col1,valor_col2,valor_col2...)
-- neste exemplo você define com base na qunatidade de colunas que tem na tabela.
```

Exemplo:

```sql

CREATE TABLE administrador(
    idadmin INTEGER GENERATED AS IDENTITY PRIMARY KEY,
    idadminfk INTEGER NULL, 
    codadmin INTEGER NOT NULL,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    senha VARCHAR(255) NOT NULL,
    dthinsert TIMESTAMP DEFAULT NOW(),
    dthdelete TIMESTAMP CHECK(dthdelete >= dthinsert OR dthdelete IS NULL), 
    statusdelete BOOLEAN DEFAULT FAlSE,
    FOREIGN KEY (idadminfk) REFERENCES administrador(idadmin)
);

-- Realizando inserções:

INSERT INTO administrador(codadmin,nome,email,senha)
VALUES(123678,'admingui','admin@gmail.com','$2b$12$e4Ym7XKPR9QPh/uRm4vHtuWmZzqOcfKTOhbsb0rxjUlRNY5l1Hm5O');
```

## INSERT COM SELECT

O comando INSERT ... SELECT é uma forma de inserir múltiplas linhas em uma tabela, copiando dados selecionados de outra tabela (ou da mesma tabela), usando uma consulta SELECT para definir quais dados serão inseridos.

**Para que serve:**

- Inserir dados derivados de uma consulta, sem precisar inserir linha a linha manualmente.

- Migrar dados entre tabelas, transformando dados durante a inserção.

- Fazer backups parciais de dados.

- Copiar registros filtrados ou transformados para outra tabela.

- Fazer inserção em massa baseada em resultados de joins, agregações, ou qualquer consulta complexa.

**Sintaxe básica:**

```sql
INSERT INTO tabela_destino (coluna1, coluna2, ...)
SELECT colunaA, colunaB, ...
FROM tabela_origem
WHERE condição;
```

### Explicação detalhada

```sql
    INSERT INTO tabela_destino (coluna1, coluna2, ...)
```
O que faz?

    Inicia uma operação de inserção na tabela chamada tabela_destino.

Parâmetros:
    
    A lista (coluna1, coluna2, ...) especifica exatamente em quais colunas da tabela destino os dados serão inseridos.

Importante:

    A ordem e a quantidade de colunas aqui devem corresponder às colunas que serão retornadas pela consulta SELECT.

```sql
SELECT colunaA, colunaB, ...
```

O que faz?
    Seleciona os dados que serão inseridos na tabela destino.

Parâmetros:
    As colunas selecionadas aqui (por exemplo, colunaA, colunaB) podem ser da tabela origem ou expressões derivadas (funções, cálculos).

Regra:
    O número e tipo das colunas selecionadas devem bater com a lista de colunas do INSERT INTO.

```sql
FROM tabela_origem
```
O que faz?
    Indica de qual tabela (ou tabelas, em consultas mais complexas) serão buscados os dados.

Pode ser:
    Uma tabela física, uma visão (view), ou até mesmo uma subconsulta.

```sql
    WHERE condição
```
O que faz?
    Filtro opcional que limita quais linhas da tabela origem serão selecionadas.

Exemplo:
WHERE idade > 18 seleciona apenas linhas com idade maior que 18.

### Exemplo prático:

```sql
INSERT INTO clientes_ativos (id_cliente, nome)
SELECT id, nome
FROM clientes
WHERE status = 'ativo';
```

### Diferenças para o insert normal

| Aspecto             | `INSERT` normal                                   | `INSERT ... SELECT`                              |
| ------------------- | ------------------------------------------------- | ------------------------------------------------ |
| Quantidade de dados | Insere uma ou poucas linhas definidas manualmente | Insere várias linhas retornadas por um `SELECT`  |
| Dados inseridos     | Valores explícitos, fixos                         | Dados provenientes de uma consulta dinâmica      |
| Uso típico          | Inserção pontual, individual                      | Inserção em lote, migração ou replicação parcial |
| Flexibilidade       | Limitada à linha fornecida                        | Alta, permite filtragem, transformação e junção  |

## UPDATE 
É o comando que utilizamos para realizar atualizações nos campos, domínios, atributos que são definidos na hora da criação das tabelas do nosso bacanco de dados, abaixo vai um exemplo da sintaxe:

```sql
UPDATE nome_tabela
SET coluna1 = valor1, coluna2 = valor2, ...
WHERE condição; -- NUNCA FAZER O UPDATE SEM WHERE SE NÃO PODES ATUALIZAR TODOS OS DADOS
```




1. UPDATE com SELECT
O UPDATE não aceita um SELECT puro diretamente para inserir valores, mas você pode usar um subquery (subconsulta) no SET ou no WHERE para atualizar dados com base em consulta.

Exemplo básico de UPDATE com subconsulta
Imagine duas tabelas:

funcionarios(id, nome, salario, depto_id)

departamentos(id, nome_depto, aumento)

Queremos atualizar o salário dos funcionários com base no aumento do departamento:

sql
Copiar
Editar
UPDATE funcionarios f
SET salario = salario + (
    SELECT aumento
    FROM departamentos d
    WHERE d.id = f.depto_id
)
WHERE EXISTS (
    SELECT 1
    FROM departamentos d
    WHERE d.id = f.depto_id
);
Aqui:

O valor do aumento vem do SELECT dentro do SET.

O WHERE EXISTS garante que só atualizamos funcionários cujo departamento existe.

2. DELETE usando SELECT no WHERE
Você pode deletar linhas com base em condições que usam subconsultas:

sql
Copiar
Editar
DELETE FROM funcionarios
WHERE depto_id IN (
    SELECT id FROM departamentos WHERE nome_depto = 'Financeiro'
);
Isto apaga todos os funcionários que trabalham no departamento 'Financeiro'.

3. UPDATE com JOIN (forma recomendada no PostgreSQL)
PostgreSQL permite UPDATE com FROM para fazer joins:

sql
Copiar
Editar
UPDATE funcionarios f
SET salario = salario + d.aumento
FROM departamentos d
WHERE f.depto_id = d.id
  AND d.nome_depto = 'Financeiro';
Resumo
Operação	Como usar SELECT?	Observação
UPDATE	Subconsulta no SET ou WHERE, ou UPDATE ... FROM (join)	Atualiza com base em dados de outra tabela
DELETE	Subconsulta no WHERE (ex: IN, EXISTS)	Deleta linhas que satisfazem a condição
INSERT	INSERT ... SELECT	Insere dados diretamente da consulta