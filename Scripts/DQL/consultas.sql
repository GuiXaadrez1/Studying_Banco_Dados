-- Consultas Rápidas para Teste!
SELECT * FROM public.administrador;
SELECT * FROM public.vendedor;
SELECT * FROM public.categoria;
SELECT * FROM public.produto;

SELECT * FROM public.venda;

-- Selecionado dados específicos das tabelas individualmente sem INNER JOIN!
SELECT vd.idvendedor, vd.nome FROM vendedor AS vd WHERE vd.statusdelete = FALSE;

-- SELECIONANDO COM INNER JOIN TODOvdS OS PRODUTOS QUE PERTENCEM A CATEGORIA ELETRÔNICOS

/*
    Primeiro passo na hora de fazer um INNER JOIN é simplemente mapear as chaves 
    estrangeirasa que vamos usar e saber quais informaçõe vou retornar de cada 
    tabela relacionada! 
    
    neste caso, irei retornar o nome da categoria, nome do produto, quantidade produto
    preço produto!

    LEMBRANDO QUE COLOCAR JOIN ON É O MESMO QUE INNER JOIN ON
*/

SELECT ct.nome, pd.nome AS "produto_nome", pd.qtd, pd.preco 
    FROM public.produto AS pd
        INNER JOIN public.categoria AS ct ON ct.idcategoria = pd.idcategoria
    WHERE ct.nome = 'Eletrônicos';

/*
    Lembrar de Utilizar o ALIASES (APELIDOS) na hora de retornar colunas de tabelas 
    diferentes porém de mesmo nome!
*/

-- Puxando os administradores que cadastraram as categorias!
SELECT adm.nome, ct.nome AS "Categoria", ct.idcategoria AS "Identificador Categoria" FROM public.categoria as ct
    JOIN public.administrador AS adm ON adm.idadmin = ct.idadmin;