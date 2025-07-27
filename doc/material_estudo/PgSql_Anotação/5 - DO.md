# Introdução
Este documento visa explicar de forma resumida para que serve o DO

## 📌 O que é DO em PostgreSQL?

O DO é uma estrutura de bloco anônimo.
Serve para executar um script PL/pgSQL que não precisa ser salvo como função.
Ideal para rodar testes, scripts rápidos ou ajustes pontuais no banco.

### Em outras palavras:

👉 Função: você cria, nomeia, salva e pode chamar depois.
👉 DO: você escreve, executa, o PostgreSQL roda e descarta.

### 📌 Sintaxe

```sql
DO $$
    BEGIN
    -- bloco PL/pgSQL aqui
    END;
$$ LANGUAGE plpgsql;
```
### 📌 Exemplo prático
✅ Exemplo real com INTO

```sql
DO $$
DECLARE
  total DOUBLE PRECISION;
BEGIN
  SELECT SUM(preco) INTO total
  FROM produto;

  RAISE NOTICE 'Total de preços: %', total;
END;
$$ LANGUAGE plpgsql;
```

### 📌 O que acontece aqui:

O bloco DO roda na hora.

DECLARE define variáveis locais (total).

SELECT INTO armazena o resultado em total.

RAISE NOTICE imprime na saída do PostgreSQL.

### 📌 Quando usar DO

Testar lógica antes de criar uma função definitiva.

Executar migrações pontuais que precisam de lógica condicional.

Rodar scripts de manutenção complexos (ex: loops, cursores).

### 📌 Limitação

O DO não pode ter parâmetros de entrada ou saída — é um bloco de execução isolado.

Para algo reutilizável, você cria uma função.








Perguntar ao ChatGPT



Ferramentas


