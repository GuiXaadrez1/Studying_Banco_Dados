-- Active: 1755555442561@@127.0.0.1@5431@sisvendas

-- a chava acima é chave_conexão com o postgres do container com o vscode

-- Criando um truncate para poder realizar os testes corretamente

TRUNCATE TABLE public.administrador;

-- Realizando delete físico na tabela administrador

DELETE FROM public.administrador;

TRUNCATE TABLE public.vendedor;

DELETE FROM public.vendedor;

TRUNCATE TABLE public.categoria;

DELETE FROM public.categoria;

TRUNCATE TABLE public.produto;

DELETE FROM public.produto;

TRUNCATE TABLE public.venda;