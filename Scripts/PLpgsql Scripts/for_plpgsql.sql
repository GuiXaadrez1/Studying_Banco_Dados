-- Active: 1750708565763@@127.0.0.1@5432@sisvendas

/* Este arquivo visa criar funções com principal objetivo praticar plpgsql */

/*
    Crie uma função usando o laço de repetição while e if, cujo rescebe um número natural
    como parâmetro, e o algoritmo deve identificar se este número faz parte da frequência
    de FIBONACCI.

    Lembrando: A sequência de Fibonacci é uma sequência numérica infinita em que cada 
    termo a partir do terceiro é a soma dos dois termos anteriores.
    
    Portanto, a sequência de Fibonacci é (1,1,2,3,5,8,13,21,34,55…)"

    Formalmente, a sequência de Fibonacci é dada por:

        F1 = 1
        F2 = 1

        Fn = Fn-1 + Fn-2, n >= 3 

    A razão entre termos consecutivos da sequência de Fibonacci: 

    Veja mais sobre "Sequência de Fibonacci" em: https://brasilescola.uol.com.br/matematica/sequencia-fibonacci.htm
    

*/
CREATE OR REPLACE FUNCTION fibonacci(num_natural INTEGER ) RETURNS VOID
AS $$
    DECLARE
        termo0 INTEGER := 0; -- termo que representa o termo atual
        termo1 INTEGER := 1; -- termo anterior
        termo2 INTEGER := 0; -- termo posterior
    BEGIN
        IF (num_natural = 0 ) THEN
            RAISE NOTICE 'O número natural pertence a sequência de Fibonacci';
            RETURN;
        ELSIF (num_natural = 1 ) THEN
            RAISE NOTICE 'O número natural pertence a sequência de Fibonacci';
            RETURN;
        ELSE
            WHILE termo0 <= num_natural LOOP
                -- validando o termo atual
                IF (termo0 = num_natural ) THEN
                    RAISE NOTICE 'O número natural pertence a sequência de Fibonacci';
                    RETURN; -- sai do loop
                ELSIF (termo0 > num_natural) THEN
                    RAISE NOTICE 'O número natural NÃO pertence à sequência de Fibonacci';
                    RETURN;
                END IF;

                -- calcula o próximo termo
                termo2 := termo1 + termo0;

                -- o anterior vira o atual 
                termo1 := termo0; 
                
                -- o atual vira o próximo
                termo0 := termo2; 
            
            END LOOP;
        END IF;
    END;
$$Language plpgsql;

-- Realizando Teste
SELECT fibonacci(32);