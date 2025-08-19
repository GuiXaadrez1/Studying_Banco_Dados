-- Active: 1755560023785@@127.0.0.1@5431@sisvendas

-- a chava acima é chave_conexão com o postgres do container com o vscode

-- Active: 1750708565763@@127.0.0.1@5432@sisvendas chave_conexão com o postgres na máquina local

-- COMETÁRIO ACIMA É A MINHA EXTENSÃO NO VSCODE QUE CONECTA COM O BANCO DE DADOS 

-- Vamos criar um banco de dados simples de um sistema de vendas para realizar os nossos treinos 
-- referente ao sql e ao plpgsql

-- LEIA TODOS OS COMENTÁRIOS !!!! 

/*

-- Comando básico para criar um banco de dados
CREATE DATABASE nome do seu banco;  


| Parâmetro    | O que faz                                  |
| ------------ | ------------------------------------------ |
| `OWNER`      | Define o dono do banco                     |
| `ENCODING`   | Define a codificação, UTF8 é padrão        |
| `LC_COLLATE` | Ordenação de strings                       |
| `LC_CTYPE`   | Tipo de classificação de caracteres        |
| `TEMPLATE`   | Normalmente `template0` para criar do zero |

-- Comando básico para renomear o banco de dados criado
ALTER DATABASE meu_banco RENAME TO nome_banco_novo;


-- Comando básico para deletar físicamente um banco de dados
DROP DATABASE IF EXISTS nome_db;


-- Forma de recriar um banco de dados no Postgre

-- Final padrão para "recriar" banco de forma idempotente:
-- Para evitar erro se não existir
DROP DATABASE IF EXISTS nome_db;

-- Cria com parâmetros explícitos
CREATE DATABASE nome_db
  WITH OWNER = nome_dono
       ENCODING = 'UTF8'
       LC_COLLATE = 'pt_BR.UTF-8'
       LC_CTYPE = 'pt_BR.UTF-8'
       TEMPLATE = template0;

*/

-- Cria com parâmetros explícitos
CREATE DATABASE sisvendas
    WITH OWNER = postgres
       ENCODING = 'UTF8'
       LC_COLLATE = 'pt_BR.UTF-8'
       LC_CTYPE = 'pt_BR.UTF-8'
       TEMPLATE = template0;

/*
    Criar tabelas no bando de dados segue a sintaxe:
        
        CREATE TABLE nome_tabela(
            <nome_coluna> TIPOS DE DADOS[...] Restrições(Constraints) [opcional...],
            -- Se houver FK
            FOREIGN KEY (domínio) REFERENCES tabela_referencia(dominio_tabela_referencia)
        );

*/


-- usando diretriz que coloca o fuso horário local nos  tipos de dados de Datas e Tempos
SET TIME ZONE 'America/Sao_Paulo';

-- o admin pode cadastrar outro admin;
CREATE TABLE administrador(
    -- GENERATED ALWAYS AS IDENTITY PRIMARY KEY MELHOR QUE SERIAL E MAIS UTILIZADO E É RECOMENDAÇÃO USAR APARTIR DA VERSÃO 10 DO POSTGRE
    idadmin INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
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

/*

    Se algum dia tiver que modficar a tabela ou na estrutura reoganizando
    as ordens da coluna, o ideal é fazer uma nova tabela com a estrtura 
    desejada e se a tabela antiga estiver dados, utilzar um SELECT com insert
    para fazer o repasse dassas informações e posteriomente deletar a tabela com
    DROP TABLE nome_tabela, e por fim alterar o nome da tabela nova para o nome 
    da tabela antiga:
     
        ALTER TABLE usuarios_novo RENAME TO usuarios;
*/

/*
    Observação:
        Tanto explicitando o tipo de dados de NULL ou não explicitando
        implicitamente o POSTGRES entende que aquele domínio é NULL ABLE
        eu acredito que o postgres faz casting para isso rsrsrs, mas é apenas teoria. 

*/

-- O administrador cadastra varios vedendores
CREATE TABLE vendedor(
    idvendedor INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    idadmin INTEGER NULL, -- Deixando NULL ABLE 
    codfun INTEGER NOT NULL, -- código do funcionário
    nome VARCHAR(255) NOT NUll,
    email VARCHAR(255) NOT NULL,
    dthinsert TIMESTAMP DEFAULT NOW(),
    dthdelete TIMESTAMP CHECK(dthdelete >= dthinsert OR dthdelete IS NULL),
    statusdelete BOOLEAN DEFAULT FAlSE,
    FOREIGN KEY (idadmin) REFERENCES administrador(idadmin)
);

-- o funcionario e o administrador podem fazer varias categorias
CREATE TABLE categoria (
    idcategoria INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    idadmin INTEGER,
    nome VARCHAR(255) NOT NULL,
    dthinsert TIMESTAMP DEFAULT NOW(),
    dthdelete TIMESTAMP CHECK(dthdelete >= dthinsert OR dthdelete IS NULL),
    statusdelete BOOLEAN DEFAULT FAlSE,
    FOREIGN KEY (idadmin) REFERENCES administrador(idadmin)
);

-- O administrador podem cadastrar varios produtos
-- uma categoria pode ter varios produtos um produtos

CREATE TABLE produto(
    idproduto INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    idadmin INTEGER, 
    idvendedor INTEGER,
    idcategoria INTEGER,
    nome VARCHAR(255) NOT NULL,
    qtd INTEGER NOT NULL,
    preco DOUBLE PRECISION  NOT NULL,
    dthinsert TIMESTAMP DEFAULT NOW(),
    dthdelete TIMESTAMP CHECK(dthdelete >= dthinsert OR dthdelete IS NULL),
    statusdelete BOOLEAN DEFAULT FAlSE,
    FOREIGN KEY (idadmin) REFERENCES administrador(idadmin),
    FOREIGN KEY (idvendedor) REFERENCES vendedor(idvendedor),
    FOREIGN KEY (idcategoria) REFERENCES categoria(idcategoria)    
);

-- funcionario pode fazer varias vendas

CREATE TABLE venda(
    idvenda INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    idvendedor INTEGER NOT NULL,
    idproduto INTEGER NOT NULL ,
    preco DOUBLE PRECISION NOT NULL,
    qtd INTEGER NOT NULL,
    dthinsert TIMESTAMP DEFAULT NOW(),
    dthdelete TIMESTAMP CHECK(dthdelete >= dthinsert OR dthdelete IS NULL),
    statusdelete BOOLEAN DEFAULT FAlSE,
    FOREIGN KEY (idvendedor) REFERENCES vendedor(idvendedor),
    FOREIGN KEY (idproduto) REFERENCES produto(idproduto)
);


