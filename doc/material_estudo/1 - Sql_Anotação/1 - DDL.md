# Introdução 
Este documento visa explicar como funciona a contrução, estrutura física do nosso banco de dados utilizando a sub-lingugaem do SQL DDL.

## DDL o que é?

**DATA DEFINATION LANGUAGE** - É a maneira como o banco de dados será definido, ou seja, é a definição da forma como os dados são estruturados e contém os comandos que interagem com os objetos do banco, isto corresponde a criação de DATABASE, SCHEMA e TABELAS através das operações do DDL (estrutura física).

### Observação:

Antes de falarmos das operações do DDL, é necessário entender a diferença entre o DATABASE e o SCHEMA.

**DATABASE** -> é o contêiner geral para todos os dados, ou seja, é o contêiner maior que contém todos os dados e objetos necessários para a aplicação ou conjuntos de aplicações.

**SCHEMA** -> é a organização lógica dentro de um banco de dados para agrupar objetos relacionados, utilizado para agrupar tabelas, funções etc. Permitindo que diferentes grupos de objetos sejam mantidos separados dentro do mesmo banco de dados. Dependendo do SGBD, faz função de DATABASE.

Geralmente o schema padrão do postgres é o public, isto é, todo banco de dados que criamos  está dentro de uma organização lógica padrão no Postgre


Estrutura do banco de dados junto com schema:

```bash
Cluster PostgreSQL (servidor)
 └── Banco de Dados (Database)
      ├── Schema: public (padrão)
      │    ├── Tabela(s)
      │    │    ├── Ex.: public.usuarios
      │    │    ├── Ex.: public.pedidos
      │    ├── View(s)
      │    │    ├── Ex.: public.vw_relatorio_pedidos
      │    ├── Function(s)
      │    │    ├── Ex.: public.fn_calcula_total()
      │    ├── Sequence(s)
      │    │    ├── Ex.: public.usuarios_id_seq
      │    └── Outros objetos
      │         ├── Índices
      │         ├── Constraints
      │         ├── Triggers
      │         ├── Types (tipos definidos pelo usuário)
      │         └── Extensions (extensões instaladas, ex.: citext)
      │
      ├── Schema: financeiro
      │    ├── Tabela(s)
      │    │    ├── Ex.: financeiro.contas
      │    │    ├── Ex.: financeiro.transacoes
      │    ├── View(s)
      │    │    ├── Ex.: financeiro.vw_saldo_contas
      │    ├── Function(s)
      │    │    ├── Ex.: financeiro.fn_calcula_saldo()
      │    ├── Sequence(s)
      │    │    ├── Ex.: financeiro.contas_id_seq
      │    └── Outros objetos
      │         ├── Índices
      │         ├── Constraints
      │         ├── Triggers
      │         ├── Types (tipos definidos pelo usuário)
      │         └── Policies (Row Level Security, se aplicável)
```

Exemplo de como funciona a criação:

```sql
-- primeiro o banco
CREATE DATABASE empresa
    -- coloquei as informações explícitas abaixo para fins didádicos
    WITH OWNER = postgres (Role padrão)
       ENCODING = 'UTF8'
       LC_COLLATE = 'pt_BR.UTF-8'
       LC_CTYPE = 'pt_BR.UTF-8'
       TEMPLATE = template0;

-- Sintaxe para criar um SCHEMA
CREATE SCHEMA <nome_schema>;

-- depois o schema 
CREATE SCHEMA financeiro;

-- você selecionar o schema, se é o financeiro ou o public
-- vou mostra com o public para facilitar o entendimento

--            primiero o schema depois a entidade.
SELECT * FROM public.usuario;

SELECT * FROM financeiro.contas;
```

## CREATE 

O comando CREATE podemos criar a estrutura física, isto é: o DATABASE (BANCO DE DADOS), SCHEMAS, TABELAS.

### CRIANDO O BANCO DE DADOS

**Sintaxe para a criação de um DATABASE (base de dados):**

```sql
    CREATE DATABASE <nome_do banco>;

    CREATE DATABASE mercado;
```    

**Preciso colocar as informações mostrados em observações?**

Não precisa. No PostgreSQL, **quase tudo isso tem valor padrão — você só detalha quando quer alterar o comportamento padrão.

O PostgreSQL faz implicitamente:

| Parâmetro    | Valor Padrão                                                                                |
| ------------ | ------------------------------------------------------------------------------------------- |
| `OWNER`      | Usuário que executa o comando (ex.: `postgres` se você estiver logado como `postgres`)      |
| `ENCODING`   | Herdado do `template1` — normalmente `UTF8`                                                 |
| `LC_COLLATE` | Herdado do `template1` — normalmente `en_US.UTF-8` ou `pt_BR.UTF-8` (depende da instalação) |
| `LC_CTYPE`   | Herdado do `template1`                                                                      |
| `TEMPLATE`   | `template1`                                                                                 |

**Então, quando usar explicitamente?**

| Parâmetro                 | Quando DEFINIR EXPLICITAMENTE                                                          |
| ------------------------- | -------------------------------------------------------------------------------------- |
| `OWNER`                   | Se quiser que **o dono seja outro usuário**, ex.: `OWNER = jose`                       |
| `ENCODING`                | Se precisar forçar UTF8 numa instalação antiga                                         |
| `LC_COLLATE` e `LC_CTYPE` | Se precisar mudar a ordenação ou classificação de caracteres (ex.: `pt_BR` vs `en_US`) |
| `TEMPLATE`                | Se precisar `template0` para evitar herdar objetos/extensões do `template1`            |

### CRIANDO AS TABELAS DENTRO DAQUELE BANCO DE DADOS

Sintaxe básica:

```sql
	-- criando o banco
    CREATE DATABASE mercado;
	
    -- sintaxe para a criação da tabela!
    CREATE TABLE <nome_da_tabela> (
	    Nome_coluna tipo de dado(domínio) constraints(restrição),
	    Nome_coluna tipo de dado(domínio) constraints (restrição),
	    Nome_coluna tipo de dado(domínio) constraints (restrição)
    );

    -- Criando tabela gerente
    CREATE TABLE gerente(
        idgerente INTEGER GENERATED ALWAYS IDENTITY PRIMARY KEY,
        idmercado INTEGER NULL,
        nome VARCHAR(100) NOT NULL  
    );

```

**Obs.:** A criação de colunas(campos) e seu devidos dados (domínios e restrições) devem estar dentro dos parênteses (...) e o ponto e vírgula “ ; ” no final é obrigatório.


## ALTER 

O ALTER permite alterar permite alterar DATABASE, SCHEMA, TABELAS. Geralmente usamos para a alteração de relações(tabelas).

Sintaxe básica para a alteração de tabelas:

```sql
    ALTER TABLE <nome_da_tabela><comandos> <ação específicas>;
```
Comandos:

- ADD COLUMN novo_atributo tipo de dado + constraints(restrição de coluna)

- ADD CONSTRAINTS nome da restrição constraints (restrição de tabela ou coluna)

- DROP COLUMN nome da coluna contrainsts (restrições de chave se houver [ RESTRICT, CASCADE])

**OBS 1.:** RESTRIÇÕES DEVEM SER ANALISADAS SE É NECESSÁRIA COLOCAR OU NÃO.

**AÇÕES ESPECÍFICAS:**

**CASCADE:** Atualiza ou exclui os registros da tabela filha automaticamente, ao atualizar ou excluir um registro da tabela pai, ou seja, A opção CASCADE permite excluir ou atualizar os registros relacionados presentes na tabela filha automaticamente, quando um registro da tabela pai for atualizado (ON UPDATE) ou excluído (ON DELETE). É a opção mais comum aplicada;

**RESTRICT:**  Rejeita a atualização ou exclusão de um registro da tabela pai, se houver registros na tabela filha, ou seja, impede que ocorra a exclusão ou a atualização de um registro da tabela pai, caso ainda haja registros na tabela filha. Uma exceção de violação de chave estrangeira é retornada. A verificação de integridade referencial é realizada antes de tentar executar a instrução UPDATE ou DELETE;

**SET NULL:**  Define como NULL o valor do campo na tabela filha, ao atualizar ou excluir o registro da tabela pai;

**SET DEFAULT:** Define o valor da coluna na tabela filha, como o valor definido como default(padrão) para ela, ao excluir ou atualizar um registro na tabela pai.

**NO ACTION:** Essa opção equivale à RESTRICT, porém a verificação de integridade referencial é executada após a tentativa de alterar a tabela. É a opção padrão, aplicada caso nenhuma das opções seja definida na criação da chave estrangeira.

**OBS.2:** AVALIE SE É NECESSÁRIO COLOCAR AS AÇÕES ESPECÍFICAS.

EXEMPLO:

```sql
    ALTER TABLE produto ADD COLUMN quantidade INT NOT NULL;
```

- Também tem como modificar e alterar as colunas da tabela, veja a sintaxe básica:

```sql
ALTER TABLE <nome da tabela> MODIFY COLUMN <nome da coluna> <novo tipo de dado> <restrição> <ações específicas>;
```

EXEMPLO:
```sql
    ALTER TABLE produto MODIFY COLUMN preco DECIMAL NOT NULL NO ACTION; 
```

## DROP

Usamos o DROP para a deleção de DATABASE (Banco de dados), SCHEMA, TABELAS, COLUNAS E RESTRIÇÕES.

### Sintaxe para a deleção de DATABASE e SCHEMA

```sql
DROP DATABASE <nome_do_banco>  <ação>;

DROP SCHEMA <nome_do_schema>;
```
Ações:

**CASCADE:** Apaga o (DATABASE) e todos os seus elementos relacionados;

**RESTRICT:** Só apaga o (DATABASE) se ele não contiver nenhum elemento ou elementos relacionados a ele;
 
EXEMPLO:

```sql
    DROP DATABASE mercado CASCADE;
```

**OBS.1:** QUANDO O BANCO DE DADOS É DELETADO, TODOS OS DADOS QUE ESTÃO CONTIDO NELE TAMBÉM É DELETADO.

**OBS.2:** AVALIE SE É NECESSÁRIO COLOCAR AS AÇÕES, CASCADE OU RESTRICT.

**Sintaxe para a deleção de TABELAS (RELAÇÕES):**

```sql
    DROP TABLE <nome_da_tabela> <ações>;
```

**Atenção! ao destruir uma tabela (dar DROP) preste atenção na restrição de chave estrangeira, uma tabela pai não pode ser destruida se a sua filha (as que tem sua fk) não ser destruida primeiro! Se tentarmos remover uma tabela pai primeiro sem remover as tabelas filhas pode ser que o nosso SGBD barre a ação, a não ser que coloquemos alguma ação específica que permite isso na criação das tabelas como no caso o CASCADE.** 

Ações:
	
**CASCADE:** Atualiza ou exclui os registros da tabela filha automaticamente, ao atualizar ou excluir um registro da tabela pai, ou seja, A opção CASCADE permite excluir ou atualizar os registros relacionados presentes na tabela filha automaticamente, quando um registro da tabela pai for atualizado (ON UPDATE) ou excluído (ON DELETE). É a opção mais comum aplicada;
	
**RESTRICT:**  Rejeita a atualização ou exclusão de um registro da tabela pai, se houver registros na tabela filha, ou seja, impede que ocorra a exclusão ou a atualização de um registro da tabela pai, caso ainda haja registros na tabela filha. Uma exceção de violação de chave estrangeira é retornada. A verificação de integridade referencial é realizada antes de tentar executar a instrução UPDATE ou DELETE;

EXEMPLO:
```sql
    DROP TABLE produto CASCADE ON DELETE;
```

**OBS 1.:** TODOS OS DADOS DA TABELA E A TABELA SERÃO EXCLUÍDOS, DELETADOS, MAS O BANCO DE DADOS AINDA EXISTIRÁ.

**OBS 2.:** AVALIE SE É NECESSÁRIO COLOCAR AS AÇÕES!


## TRUNCATE
Com o TRUNCATE podemos excluir todos os registros(linha) de uma TABELA, em uma única instrução. 

Serve como a query DELETE do DML sem a CLÁSULA WHERE. Ou seja, exclui todos os registros, tuplas, linhas de uma tabela, porém não é realizado um registro de log de cada linha excluída. Por isso, é preciso tomar muito cuidado ao decidir usar esse comando. Dependendo do SGBD usado, não é possível realizar ROLLBACK após executar o 
TRUNCATE. Já quando fazemos um DELETE sem WHERE, temos todos os registros em um log que é possível recuperar com o ROLLBACK.

**Sintaxe básica do comando TRUNCATE:**

```sql
-- como fazer:
TRUNCATE TABLE <nome_da_table>;
 
-- fazendo:
TRUNCATE TABLE produtos;
```

