# Introdução 

# Sintaxe básica do PL/PgSql

No PL/pgSQL, uma função armazenada (stored function) sempre segue esta estrutura principal:

```sql
[<<rótulo>>] (CREATE FUNCTION OR RAPLACE <nome>(tipo,tipo)
Returns <tipo>) AS $$ 
[DECLARE
    Variável Tipos;
]
BEGIN 

    // lembre-se instruções lógicas, lógica de programação
    instruções; 

    // valor de retorno após as intruções lógicas ou lógica de programação
    return <valor_retorno> 
END
$$Language plpgsql;
```

## ✅ Vamos decompor o seu exemplo

### [<<rótulo>>]

Rótulos em PL/pgSQL são opcionais — servem para dar nome a blocos BEGIN/END ou laços.

Úteis quando você precisa de controle de fluxo mais complexo (ex: EXIT <<rótulo>> para sair de loops aninhados).

💡 Em 90% das funções comuns, você não usa rótulo. É mais avançado.

### CREATE FUNCTION

- CREATE FUNCTION → cria uma nova função.

- OR REPLACE → sobrescreve se já existir.

- <nome> → nome da função.

- (<parâmetros>) → lista de parâmetros de entrada com tipos.

### RETURNS <tipo>

```sql
RETURNS <tipo>
```
Indica qual tipo de valor a função vai devolver, exemplo:

    RETURNS INTEGER → devolve inteiro.

    RETURNS TEXT → devolve texto.

    RETURNS TABLE(...) → devolve uma tabela.

    RETURNS VOID → não retorna nada.

    RETURNS numeric → retorna valores numéricos

##  AS $$ ... $$

```sql
AS $$
  DECLARE ...
  BEGIN ...
  END;
$$
```

- $$ é o delimitador do corpo da função.

- Dentro fica seu bloco PL/pgSQL procedural.

### DECLARE (opcional)
Poder opcional, porém, pode ser interessantes saber usar

```sql
DECLARE
   variavel tipo;
```

- Define variáveis locais dentro da função.

- Se não precisar de variáveis, pode omitir o DECLARE.

- Cada variável deve ter tipo PostgreSQL: INTEGER, TEXT, NUMERIC etc.

### BEGIN ... END;

```sql
BEGIN
  -- instruções SQL e lógica
  RETURN valor;
END;
```

O coração da função.

Tudo entre BEGIN e END; é a lógica procedural:

    IF, LOOP, RAISE NOTICE, SELECT INTO, INSERT…

    RETURN é obrigatório se sua função RETURNS algo que não seja VOID.

### LANGUAGE plpgsql

```sql
LANGUAGE plpgsql;
```

Define a linguagem usada para interpretar o corpo da função.

PostgreSQL suporta outras (sql, plpythonu etc.), mas plpgsql é padrão para lógica procedural.

## Exemplo Prático: 
```sql
CREATE OR REPLACE FUNCTION media_aritimetica(a numeric, b numeric) RETURNS numeric AS
$$
    DECLARE resultado real
    BEGIN
        result := (a+b)/2;
        RETURN result;
    END; -- (opcional)
$$
LANGUAGE plpgsql;
```

## Resumo do formato

Lembrando que PostgreSQL suporta outras (sql, plpythonu etc.), mas plpgsql é padrão para lógica procedural.

| Bloco              | O que faz                   |
| ------------------ | --------------------------- |
| `CREATE FUNCTION`  | Cria/atualiza a função      |
| `RETURNS`          | Define o tipo de retorno    |
| `DECLARE`          | Variáveis locais (opcional) |
| `BEGIN ... END`    | Bloco lógico                |
| `RETURN`           | Valor final                 |
| `LANGUAGE plpgsql` | Linguagem usada             |


## Linguagens nativas ou oficiais

São as linguagens instaladas por padrão ou mantidas pelo core do PostgreSQL:

| Linguagem     | Descrição                                                                                          |
| ------------- | -------------------------------------------------------------------------------------------------- |
| **SQL**       | Linguagem padrão do banco relacional. Simples, declarativa.                                        |
| **PL/pgSQL**  | Procedural SQL nativo, padrão para triggers e lógica dentro do banco.                              |
| **C**         | Usada para criar funções de alto desempenho no nível do sistema (mais avançado).                   |
| **PL/Tcl**    | Interface para a linguagem Tcl (menos comum, mas oficial).                                         |
| **PL/Perl**   | Permite escrever funções usando Perl.                                                              |
| **PL/Python** | Executa funções em Python dentro do banco. Duas variantes: `plpythonu` (untrusted) e `plpython3u`. |

## Linguagens “trusted” e “untrusted”
No PostgreSQL, algumas linguagens podem rodar em modo:

    trusted (segura): Restringida, sem acesso ao sistema operacional.

    untrusted: Sem restrições — acesso total ao sistema OS via função — precisa de superusuário.

Exemplo:

    plpythonu → u = untrusted, pode rodar qualquer código Python no servidor.

## Linguagens de terceiros (extensões)

A comunidade PostgreSQL tem extensões para dar suporte a muitas linguagens externas. Exemplos famosos:

| Linguagem         | Descrição                                                               |
| ----------------- | ----------------------------------------------------------------------- |
| **PL/Java**       | Escreve funções/procedimentos em Java.                                  |
| **PL/V8**         | Usa o engine Google V8 para rodar JavaScript no banco.                  |
| **PL/R**          | Permite rodar scripts de análise estatística em R dentro do PostgreSQL. |
| **PL/Ruby**       | Suporte experimental para Ruby.                                         |
| **PL/Lua**        | Linguagem Lua embutida.                                                 |
| **PL/Go** (pl/go) | Para usar funções em Go (pode precisar de extensões de terceiros).      |


## Linguagens SQL externas / frameworks

Além das linguagens procedurais, o PostgreSQL suporta extensões que integram outras linguagens via Foreign Data Wrappers (FDW).
Exemplo: usar Python ou Java para manipular dados externos como se fossem tabelas do PostgreSQL.

## Resumo: tabela prática

| Categoria               | Linguagens                                                |
| ----------------------- | --------------------------------------------------------- |
| **Core**                | SQL, PL/pgSQL, C                                          |
| **Oficiais / mantidas** | PL/Python, PL/Perl, PL/Tcl                                |
| **Extensões comuns**    | PL/Java, PL/V8 (JavaScript), PL/R, PL/Ruby, PL/Lua, PL/Go |

## Como ver as linguagens instaladas no seu PostgreSQL?

```sql
SELECT lanname FROM pg_language;
```
Resultado típico:
```markdown
 lanname
---------
 sql
 plpgsql
 c
```
Você verá plpgsql, sql e c como padrão.

Para usar outras (ex: Python), você precisa rodar:

```sql
CREATE EXTENSION plpython3u;
```

(precisa ter sido compilado com suporte a essa linguagem.)

## Atenção
Nem toda linguagem é habilitada por padrão.

Linguagens “não confiáveis” (untrusted) exigem permissão de superusuário.

Usar linguagens externas dentro do banco pode aumentar a superfície de ataque — só use se fizer sentido arquiteturalmente.

## Resumo sobre as linguagens:

| Você quer                 | Faça isso                |
| ------------------------- | ------------------------ |
| Procedural clássico       | Use **PL/pgSQL**         |
| Funções especiais         | Use **C** (baixa camada) |
| Scripts Python            | **PL/Python**            |
| Machine Learning no banco | **PL/R**, **PL/Python**  |
| JavaScript no banco       | **PL/V8**                |
| Java dentro do PostgreSQL | **PL/Java**              |

## Exemplo usando outra linguagem

Função em PL/Python
Objetivo: Criar uma função que recebe uma lista de números e retorna a soma.

```sql
-- Cria extensão se não existir
CREATE EXTENSION IF NOT EXISTS plpython3u;

-- Cria função PL/Python
CREATE OR REPLACE FUNCTION soma_lista(numeros double precision[])
RETURNS double precision AS $$
    return sum(numeros)
$$ LANGUAGE plpython3u;
```

**observação:** 
Faça pesquisas mais profundas caso queria usar esse recurso
Mas por motivos de segurança, use o PL/pgsql, SQL ou o C mesmo kaakkaka

## Orientações finais 
Sempre feche com ponto-e-vírgula (;) no final da definição (END; + $$ LANGUAGE plpgsql;).

DECLARE é opcional, mas BEGIN ... END é obrigatório.

Use $$ ou $$BODY$$ como delimitador — padrão do PostgreSQL.