-- Active: 1750708565763@@127.0.0.1@5432@sisvendas@public

/*Vamos criar uma função simples para entender a sintaxe do plpgsql*/

CREATE OR REPLACE FUNCTION resultado_soma(a  numeric b numeric) RETURN numeric
AS $$
    DECLARE
        resultado numeric;
    BEGIN
        result := (a+b)/2;
        RETURN result;
    END; (opcional colocar o ;)
$$Language plpgsql;

/*
    Crie Função que calcula o total de faturamento ao vender todos os produtos 
    cadastrados pela quantidade vezes o seu preço de venda, isto é:
        quantidade_produto x preco_venda
    não vai ser necessário colocar parâmetros!

*/

CREATE OR REPLACE FUNCTION calc_fat_prod(produto_nome VARCHAR(255)) 
RETURNS DOUBLE PRECISION
AS $$
    DECLARE
        resultado DOUBLE PRECISION;
    BEGIN
        SELECT SUM(pd.qtd * pd.preco)
        INTO resultado
        FROM produto AS pd 
        WHERE pd.nome = produto_nome;

        RETURN resultado;
    END;
$$ LANGUAGE plpgsql;

/*

    Em PL/pgSQL (a linguagem procedural do PostgreSQL), o INTO é usado para capturar o 
    resultado de uma consulta e armazenar esse resultado em variáveis locais da função ou 
    bloco DO.

*/

-- Para chamar, usar uma função, usa-se o SELECT

SELECT calc_fat_prod('Redm 13');

/*
    Cria uma função que retorne uma trigger que ao inserir um registro na tabela 
    que diminua a subtraia a qauntidade de produto (Entidade produto) pela quantidade
    de produtos vendidos (Entidade venda!). Logo:
        qtd_prod - qtd_venda = new resultado;
*/ 

CREATE OR REPLACE FUNCTION atualizar_estoque()
RETURNS TRIGGER 
AS $$
    BEGIN
        -- Atualiza a tabela produto, subtrai a quantidade vendida
        UPDATE produto
        SET qtd = qtd - NEW.qtd -- o NEW.qtd é a quantidade que vem da tabela referenciada venda ao ativar a trigger de after insert
        WHERE idproduto = NEW.idproduto;

        -- Retorna a linha da venda normalmente
        RETURN NEW;
    END;
$$ 
LANGUAGE plpgsql;

-- Esta função `atualizar_estoque` é uma função de gatilho (TRIGGER) escrita em PL/pgSQL, vinculada à tabela `venda`.
-- Ela é chamada automaticamente toda vez que uma nova linha é inserida na `venda`, pois o gatilho é configurado como `AFTER INSERT`.
-- Dentro do bloco `BEGIN ... END`, o objetivo é atualizar a coluna `qtd` da tabela `produto`, subtraindo a quantidade que acabou de ser vendida.
-- O `NEW.qtd` representa a quantidade de produtos vendidos informada no comando `INSERT INTO venda (...) VALUES (...)`; o PostgreSQL cria o registro especial `NEW` com todos os campos da nova linha.
-- Assim, `NEW.qtd` e `NEW.idproduto` não são declarados manualmente na função: eles são fornecidos pelo mecanismo interno do TRIGGER, permitindo acessar os valores recém-inseridos sem SELECTs adicionais.
-- No entanto, o `SET SUM(qtd = qtd - NEW.qtd)` está incorreto: `SUM()` é uma função de agregação usada em SELECTs, não faz sentido em um UPDATE isolado.
-- O correto é usar `SET qtd = qtd - NEW.qtd`, que ajusta a coluna `qtd` do produto diretamente, reduzindo o estoque de acordo com o volume da venda.
-- Por fim, `RETURN NEW;` informa ao PostgreSQL que a operação do gatilho foi concluída e que a linha inserida na `venda` deve ser mantida como está no banco.
-- Resumindo: o `NEW` é o registro especial que carrega os valores da operação DML disparadora (INSERT, UPDATE ou DELETE), tornando possível reagir dinamicamente dentro do PL/pgSQL.


-- CRAINDO A NOSSA TRIGGER
CREATE TRIGGER att_estoque
    AFTER INSERT ON venda -- Não esquecer do ON para referenciar a tabela
    FOR EACH ROW
    EXECUTE PROCEDURE atualizar_estoque();

-- CONSULTANDO INFORMAÇÕES NA TABELA produto
SELECT * FROM produto;

-- O produto SAMSUNG S24 ULTRA tem 5 em estoque atualmente

-- INSERINDO REGISTROS NA TABELA VENDA!
INSERT INTO public.venda (idvendedor,idproduto,preco,qtd)
VALUES(5,1,5556.55,3);

-- CONSULTANDO INFORMAÇÕES 
SELECT * FROM produto;