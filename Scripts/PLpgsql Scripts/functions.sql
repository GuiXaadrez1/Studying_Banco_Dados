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