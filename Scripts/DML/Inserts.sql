-- Active: 1750708565763@@127.0.0.1@5432@sisvendas

-- Criando NOSSOS INSERTS e SELECTS BÁSICOS
SELECT * FROM administrador;

-- Inserir 2 admins 

INSERT INTO public.administrador (codadmin,nome,email,senha)
VALUES(123456,'admingui','admingui@gmail.com',MD5('123456'));

INSERT INTO public.administrador (codadmin,nome,email,senha)
VALUES(123456,'adminfab','adminfab@gmail.com',MD5('123457'));

-- Atualizando o codadmin do adminfb
UPDATE public.administrador SET codadmin = 123457 WHERE idadmin = 2;

-- Inserindo 5 vendedores 

SELECT * FROM public.vendedor;
INSERT INTO public.vendedor(idadmin,codfun,nome,email) 
VALUES (1,123568,'José Antônio', 'José@gmail.com');

INSERT INTO public.vendedor(idadmin,codfun,nome,email) 
VALUES (1,123569,'Maria Rosa Linda', 'LindaRosa@gmail.com');

INSERT INTO public.vendedor(idadmin,codfun,nome,email) 
VALUES (1,123521,'Matheus Mathias', 'Mttm@gmail.com');

INSERT INTO public.vendedor(idadmin,codfun,nome,email) 
VALUES (1,123511,'Raimundo Souza Pimenta', 'SouzaPimenta@gmail.com');

INSERT INTO public.vendedor(idadmin,codfun,nome,email) 
VALUES (1,123568,'Paulo Jorge', 'PL@gmail.com');

-- Atualizando o codfun de um funcionários 
UPDATE public.vendedor SET codfun = 123566 WHERE nome = 'Paulo Jorge';

-- Inserindo multiplos dados de forma manual na tabela categoria

SELECT * FROM public.categoria;

INSERT INTO public.categoria (idadmin, nome)
VALUES 
    (1,'Eletrônicos'),
    (1,'Roupas'),
    (2,'Beleza Feminina'),
    (2,'Roupas Masculino'),
    (1,'Alimentos'),
    (2,'Limpeza');

-- Deletando Lógicamente dois vendedores!

UPDATE public.vendedor SET statusdelete = TRUE 
WHERE nome = 'Paulo Jorge';

UPDATE public.vendedor SET statusdelete = TRUE 
WHERE nome = 'Matheus Mathias';

-- Realizando filtro básico para retornar os vendores que não foram deletados lógicamente!

SELECT * FROM public.vendedor WHERE statusdelete = FALSE;

-- Realizando filtro básico para retornar os vendores que foram deletados lógicamente!
SELECT * FROM public.vendedor WHERE statusdelete = TRUE;

-- Inserindo dados em produto!

SELECT * FROM public.produto;

INSERT INTO public.produto (idadmin,idcategoria,nome,qtd,preco)
VALUES
    (1,1,'SAMSUNG S24 ULTRA',5,5556.55),
    (1,1,'Redm 13',5,1078.00),
    (2,1,'Notebook Acer Nitro V15 ANV15-51-58AZ',4,4559.05),
    (2,1,'Notebook Core I5 Dell Latitude',3,2261.00);

INSERT INTO public.produto (idvendedor,idcategoria,nome,qtd,preco)
VALUES
    (1,2,'Camisa Social Manga Longa', 50, 1219.00),
    (2,6,'Limpador Multiuso 500ml Veja',100,3.99),
    (2,6,'Limpeza Pesada LP',150,42.67),
    (1,6,'Desinfetante Vim Espuma Poderosa 450ml',35,10.98),
    (5,3,'Delineado Ruby Rose',50,7.99),
    (5,5,'Arroz Tio Jorge 5KG', 250, 15.00),
    (5,6,'QBOA 2L', 100, 10.99),
    (2,5,'Arroz Tio João 5KG',250,32.99),
    (1,5,'Ervilha e Milho Quero',500,5.04);
