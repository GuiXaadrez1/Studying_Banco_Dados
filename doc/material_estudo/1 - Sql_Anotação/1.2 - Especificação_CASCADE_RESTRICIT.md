# Introdução 
Este documento visa dazer uma observação rápida sobre as políticas de remoção e Atualização de Dados: CASCADE, RESTRICT, SET NULL...

**observações:** ESSAS POLÍTICAS DE REMOÇÃO E ATUALIZAÇÃO SEMPRE FICAM NA TABELA FILHA (tabela que contém a chave estrangeira da tabela pai) e a tabela pai é a tabela que tem uma primary key que serve de chave estrangeira para outras tabelas que posteriomente são chamadas de tabelas filhas, porque dependem da existência desta tabela. 

## CASCADE

Definição: Quando dizemos que uma chave estrangeira da tabela filha tem a política de remoção ou atualização (ON UPDATE) | (ON DELETE) CASCADE na hora da implementação no momento da criação da tabela. A remoção ou atualização de uma linha em uma tabela pai remove ou atualiza automatica as linhas referenciadas nasa tabelas filhas.

Exemplo:

```sql
-- Craindo banco de dados

CREATE DATABASE sisvendas;

-- Criando Schema 

CREATE SCHEMA sistema_vendas;

-- CRAINDO tabela no SCHEMA
CREATE TABLE sistema_vendas.administrador(
    -- GENERATED ALWAYS AS IDENTITY PRIMARY KEY MELHOR QUE SERIAL E MAIS UTILIZADO E É RECOMENDAÇÃO USAR APARTIR DA VERSÃO 10 DO POSTGRE
    idadmin INTEGER GENERATED AS IDENTITY PRIMARY KEY,
    idadminfk INTEGER NULL, -- VAMOS PERMITIR QUE SEJA NULL ABLE ( permiter valores NULOS)
    codadmin INTEGER NOT NULL, -- código do administrador
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    senha VARCHAR(255) NOT NULL,
    dthinsert TIMESTAMP DEFAULT NOW(),
    dthdelete TIMESTAMP CHECK(dthdelete >= dthinsert OR dthdelete IS NULL), -- validação do delete lógico, a data de insart não pode ser menor, permitir NULL ABLE
    statusdelete BOOLEAN DEFAULT FAlSE,
    FOREIGN KEY (idadminfk) REFERENCES administrador(idadmin)
);

-- CRAINDO TABELA NO SCHEMA
CREATE TABLE sistema_vendas.vendedor(
    idvendedor INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    idadmin INTEGER NULL, -- Deixando NULL ABLE 
    codfun INTEGER NOT NULL, -- código do funcionário
    nome VARCHAR(255) NOT NUll,
    email VARCHAR(255) NOT NULL,
    dthinsert TIMESTAMP DEFAULT NOW(),
    dthdelete TIMESTAMP CHECK(dthdelete >= dthinsert OR dthdelete IS NULL),
    statusdelete BOOLEAN DEFAULT FAlSE,
    
    -- ESTAMOS DEFININDO UMA POLÍTICA DE ATUALIZAÇÃO E REMOÇÃO CASCADE

    FOREIGN KEY (idadmin) REFERENCES administrador(idadmin) 
        ON DELETE CASCADE
        ON UPDATE CASCADE

        -- OPTEI EM COLOCAR AS DUAS POLÍTICAS PARA FINS DIDÁTICOS
        -- VOCÊ PODE COLOCAR MISTA  

        -- CASCADE PARA REMOÇÕES
        ON DELETE CASCADE

        -- RESTRICT PARA ATUALIZAÇÕES 
        ON UPDATE RESTRICT 
);

```

### Caso misture as politicas de remoção e ataulização

O POSTGRESQL tem suporte para aceita ações independentes para DELETE e UPDATE nas tabelas filhas.

| Cláusula             | O que faz                                                                                                                                     |
| -------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- |
| `ON DELETE CASCADE`  | Quando o registro pai (`administrador`) for excluído, apaga automaticamente os filhos (`vendedor`).                                           |
| `ON UPDATE RESTRICT` | Se alguém tentar atualizar a PK `idadmin` da tabela `administrador` **enquanto houver filhos**, o PostgreSQL **bloqueia** — impede atualizar. |


## RESTRICT

Definição: Quando dizemos que uma chave estrangeira da tabela filha tem a política de remoção ou atualização (ON UPDATE) | (ON DELETE) RESTRICT na hora da implementação no momento da criação da tabela. A remoção ou ataulização de uma linha de uma tabela pai só ocorre após a remoção ou atualização das linhas referenciadas nas tabelas filhas.

EXEMPLO:
```sql
-- Craindo banco de dados

CREATE DATABASE sisvendas;

-- Criando Schema 

CREATE SCHEMA sistema_vendas;

-- CRAINDO tabela no SCHEMA
CREATE TABLE sistema_vendas.administrador(
    -- GENERATED ALWAYS AS IDENTITY PRIMARY KEY MELHOR QUE SERIAL E MAIS UTILIZADO E É RECOMENDAÇÃO USAR APARTIR DA VERSÃO 10 DO POSTGRE
    idadmin INTEGER GENERATED AS IDENTITY PRIMARY KEY,
    idadminfk INTEGER NULL, -- VAMOS PERMITIR QUE SEJA NULL ABLE ( permiter valores NULOS)
    codadmin INTEGER NOT NULL, -- código do administrador
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    senha VARCHAR(255) NOT NULL,
    dthinsert TIMESTAMP DEFAULT NOW(),
    dthdelete TIMESTAMP CHECK(dthdelete >= dthinsert OR dthdelete IS NULL), -- validação do delete lógico, a data de insart não pode ser menor, permitir NULL ABLE
    statusdelete BOOLEAN DEFAULT FAlSE,
    FOREIGN KEY (idadminfk) REFERENCES administrador(idadmin)
);

-- CRAINDO TABELA NO SCHEMA
CREATE TABLE sistema_vendas.vendedor(
    idvendedor INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    idadmin INTEGER NULL, -- Deixando NULL ABLE 
    codfun INTEGER NOT NULL, -- código do funcionário
    nome VARCHAR(255) NOT NUll,
    email VARCHAR(255) NOT NULL,
    dthinsert TIMESTAMP DEFAULT NOW(),
    dthdelete TIMESTAMP CHECK(dthdelete >= dthinsert OR dthdelete IS NULL),
    statusdelete BOOLEAN DEFAULT FAlSE,
    
    -- ESTAMOS DEFININDO UMA POLÍTICA DE ATUALIZAÇÃO E REMOÇÃO RESTRICT 

    FOREIGN KEY (idadmin) REFERENCES administrador(idadmin)

    -- ATENÇÃO, NÃO COLOCAR NADA É O MESMO QUE: 

    FOREIGN KEY (idadmin) REFERENCES administrador(idadmin)
        ON UPDATE RESTRICT 
        ON UPDATE RESTRICT
);
```

## SET NULL

Definição: Quando dizemos que uma chave estrangeira da tabela filhatem a política de remoção ou atualização (ON UPDATE) | (ON DELETE) SET NULL a hora da implementação no momento da criação da tabela. A remoção ou atualização de uma linha em uma tabela pai, coloca valor NULL em todas as linhas referenciadas nas tabelas filhas.

EXEMPLO:

```sql
-- Craindo banco de dados

CREATE DATABASE sisvendas;

-- Criando Schema 

CREATE SCHEMA sistema_vendas;

-- CRAINDO tabela no SCHEMA
CREATE TABLE sistema_vendas.administrador(
    -- GENERATED ALWAYS AS IDENTITY PRIMARY KEY MELHOR QUE SERIAL E MAIS UTILIZADO E É RECOMENDAÇÃO USAR APARTIR DA VERSÃO 10 DO POSTGRE
    idadmin INTEGER GENERATED AS IDENTITY PRIMARY KEY,
    idadminfk INTEGER NULL, -- VAMOS PERMITIR QUE SEJA NULL ABLE ( permiter valores NULOS)
    codadmin INTEGER NOT NULL, -- código do administrador
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    senha VARCHAR(255) NOT NULL,
    dthinsert TIMESTAMP DEFAULT NOW(),
    dthdelete TIMESTAMP CHECK(dthdelete >= dthinsert OR dthdelete IS NULL), -- validação do delete lógico, a data de insart não pode ser menor, permitir NULL ABLE
    statusdelete BOOLEAN DEFAULT FAlSE,
    FOREIGN KEY (idadminfk) REFERENCES administrador(idadmin)
);

-- CRAINDO TABELA NO SCHEMA
CREATE TABLE sistema_vendas.vendedor(
    idvendedor INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    idadmin INTEGER NULL, -- Deixando NULL ABLE 
    codfun INTEGER NOT NULL, -- código do funcionário
    nome VARCHAR(255) NOT NUll,
    email VARCHAR(255) NOT NULL,
    dthinsert TIMESTAMP DEFAULT NOW(),
    dthdelete TIMESTAMP CHECK(dthdelete >= dthinsert OR dthdelete IS NULL),
    statusdelete BOOLEAN DEFAULT FAlSE,
    
    -- ESTAMOS DEFININDO UMA POLÍTICA DE ATUALIZAÇÃO E REMOÇÃO SET NULL

    FOREIGN KEY (idadmin) REFERENCES administrador(idadmin)
        ON UPDATE SET NULL
        ON UPDATE SET NULL
);
```