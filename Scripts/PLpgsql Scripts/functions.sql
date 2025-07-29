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
    DECLARE
        qtd_estoque INTEGER;
    BEGIN
        
        -- Bloqueia a linha do produto para evitar corrida
        SELECT qtd INTO qtd_estoque 
        FROM produto 
        WHERE idproduto = NEW.idproduto
        FOR UPDATE;

        IF qtd_estoque < NEW.qtd THEN 
            RAISE EXCEPTION 'Quantidade indisponível em estoque.';
        ELSE
            UPDATE produto
            SET qtd = qtd_estoque - NEW.qtd
            WHERE idproduto = NEW.idproduto;

            RETURN NEW;
        END IF;
    END;
$$ 
LANGUAGE plpgsql;

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

-- INSERINDO REGISTROS NA TABELA VENDA NOVAMENTE!
INSERT INTO public.venda (idvendedor,idproduto,preco,qtd)
VALUES(1,11,10.99,50);

/*

INSERT INTO public.venda (idvendedor,idproduto,preco,qtd)
VALUES(1,11,10.99,51);
Retorna o error: Error: Quantidade indisponível em estoque.

Trigger atualizada e arrumada perfeitamente.
*/


/*
    Cria uma função que retorne o valor total de venda de um produto, isto é
    a quantidade do produto vendido vezes o seu valor.
    exemplo: (qtd_venda * preco_venda);
*/ 

-- CRIANDO A FUNÇÃO QUE FAZ ISSO PARA TODOS OS PRODUTOS
CREATE OR REPLACE FUNCTION valor_total_venda() 
RETURNS TABLE (nome_produto VARCHAR(255), total_venda DOUBLE PRECISION)
AS $$
    BEGIN 

        RETURN QUERY
            SELECT pd.nome AS nome_produto, vd.qtd * vd.preco AS total_venda
            FROM venda vd
            JOIN produto pd ON pd.idproduto = vd.idproduto;
    END;    
$$
LANGUAGE plpgsql;

-- Como a função está retornando uma tabela para pré-visualizar os dados... 
-- podemos usar um SELECT selecionando todas as colunas...ABORT
-- Basicamente funciona igual uma view
SELECT * FROM valor_total_venda();
