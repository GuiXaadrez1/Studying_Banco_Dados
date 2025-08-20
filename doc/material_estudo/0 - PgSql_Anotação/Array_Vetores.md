# Introdução 

Um array é uma estrutura de dados composta que armazena uma coleção ordenada de elementos do mesmo tipo. 

No PostgreSQL, arrays são homogêneos, ou seja, todos os elementos devem ser do mesmo tipo de dado (inteiro, texto, data, booleano, etc.), garantindo consistência e previsibilidade nas operações de manipulação. Arrays não são heterogêneos, portanto não permitem misturar tipos diferentes em um mesmo array.

## Dimensionalidade

Arrays podem ter uma ou mais dimensões, permitindo organizar dados de formas complexas:

**Unidimensional – Lista linear de elementos. Veja como uma linha**
Exemplo: {1,2,3,4,5}

**Bidimensional – Matriz de linhas e colunas. Veja como se fosse uma tabela**
Exemplo: {{1,2,3},{4,5,6}}

**Multidimensional (três ou mais dimensões) – Estruturas complexas, como cubos de dados. Muito usado em processamento de imagens, vídeos e geoprocessamento.**

Exemplo: {{{1,2},{3,4}},{{5,6},{7,8}}}

## Características principais

- Tamanho dinâmico: Não há necessidade de definir o tamanho do array previamente.

- Indexação: Os elementos são acessados por índices inteiros, começando em 0.

- Flexibilidade: Arrays podem ser usados em colunas de tabelas, funções e variáveis temporárias.

- Homogeneidade: Todos os elementos do array são do mesmo tipo, garantindo operações consistentes.

Arrays são úteis para armazenar listas ou coleções temporárias, mas seu uso em tabelas não normalizadas pode ser problemático. Para dados persistentes multivalorados, o ideal é criar uma tabela separada com relacionamento 1:N.

## Como declarar um array no Postgres?

Em plsql, os arrays não precisam ter o tamanho pré-definido como em C, ou seja, eles não possuem limites e não tem um valor contante de armazenamento.

## Declaração de Arrays

```sql
nome_array tipo_de_dado[]
```

**Exemplo:**

```sql
notas integer[]
nomes varchar[]
nascimento date[]

```

**Exemplos de atualizações de valores:**

```sql
--Atualizando a nota pelo indície dele

Notas[0] = 8;

Notas[1] = 9;

-- Utilizando chaves para representrar uma sequência de indicies começando do zero.
--       0 1 
Notas = {8,9}

-- ou seja, no array Notas, os valores no indicie 0 e 1 serão atualizados diretamente, ou seja, isso modifica o array original criado.
```

## Arrays em tabelas

Embora não seja uma boa prática em termos de normalização, arrays podem ser usados como atributos multi-valorados:

```sql
CREATE TABLE contato(
    id INTEGER GENERATED ALWAYS IDENTITY PRIMARY KEY,
    nome VARCHAR(255),
    telefone TEXT []; -- O array serve como um atributo multi-valorado
    -- porém fazer desta forma não é uma boa prática, visto que vai contre a normalização.
    -- o certo seria criar uma outra tabela específica e criar um relacionamento 1 para N
);

-- Inserindo dados

INSERT INTO contato (nomes, telefone) 
VALUES ('Jotinha','{"(408)-589-5842"},{"(408)-589-58423"}');

```

Observação: O ideal para normalização é criar uma tabela de telefones separada e relacionar via chave estrangeira.

## Funções que retornam Arrays

```sql
CREATE OR REPLACE FUNCTION seq_naturais (n INTEGER) RETURNS INTEGER[] 
AS$$ 
    DECLARE
        i integer;
        res integer[];
    BEGIN
        IF n > 0 THEN
            FOR i in 1..n LOOP
                res[i] = i;
            END LOOP;
            RETURN res;
        ELSE:
            RAISE NOTICE "O número não pertence à cetegoria dos naturais ";
        END IF;
    END;
$$ 
Language plpgsql;


SELECT seq_naturais(15);
-- saida vai ser um vetor de 1 até 15: {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15}
```

```sql
CREATE OR REPLACE FUNCTION aniversariantes_mes(mes INTEGER) RETURNS INTEGER[]
AS $$ 
    DECLARE 
        i INTEGER; -- indície 
        res INTEGER[]; -- nosso vertor de resultados
        tuple RECORD; -- poderiamso colocar o tipo de dado %ROWTYPE que daria no mesmo
        mes_aniversario INTEGER;    
    BEGIN
        FOR tupla IN SELECT * FROM empregado LOOP


            SELECT EXTRACT (MONTH FROM tupla.dt_niver) INTO mes_aniversario;

            -- tupla.dt_niver estamos extraindo o mês da tabela retornada pelo select e atrinuida a variável tupla, e estamos atribuindo este valor a nossa variável mes_aniversario

            IF mes_aniversario = mes THEN
                
                -- se o mes retorando no nosso for for igual ao calor que passamos na variável que possui parâmetro de entrada IN

                res[i] := tuple.cod_emp;
                
                -- atribuimos o código do funcionário no nosso array de resultado    
                
                i := i + 1; -- atualizamos o nosso incrementador
            
            END IF; -- terminar o nosso if

        END LOOP;
    
        -- retornando o nosso vetor de resultados
        RETURN res;
    
    END;
$$
Language plpgsql;
```

## Boas Práticas

- Utilize arrays apenas para dados temporários ou cálculos internos.

- Para armazenamento persistente de dados multivalorados, use tabelas relacionadas.

- Prefira arrays unidimensionais para simplicidade.

- Use funções PL/pgSQL para manipulação, filtragem e retorno de arrays.

- Combine arrays com CTEs e joins quando necessário para processamento mais complexo.

## Aplicações Reais

- Retornar listas de IDs ou códigos em funções.

- Armazenar dados temporários durante cálculos internos em PL/pgSQL.

- Criar coleções de resultados para análises internas sem criar tabelas físicas.

- Modelar sequências, grades ou matrizes temporárias de dados.