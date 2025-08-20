# Transaction Control Language (TCL) no PostgreSQL

## O que é TCL?

TCL (Transaction Control Language) é a subcategoria de comandos SQL responsável por gerenciar transações em um banco de dados relacional.
Enquanto DDL (Data Definition Language) define estruturas (tabelas, índices, etc.) e DML (Data Manipulation Language) manipula dados (INSERT, UPDATE, DELETE), o TCL garante consistência, atomicidade e integridade durante as operações.

Em outras palavras:

👉 Se DML mexe nos dados, o TCL decide quando essas alterações passam a valer (commit) ou quando devem ser desfeitas (rollback).

No PostgreSQL, toda sessão de conexão pode conter uma ou várias transações, que são blocos lógicos de operações que devem ser executadas como uma unidade.

## 🔑 Conceito de Transação

Uma transação é um conjunto de instruções SQL que devem ser executadas juntas, garantindo as propriedades ACID:

**Atomicidade** → Tudo ou nada (ou todas as operações são aplicadas, ou nenhuma é).

**Consistência** → O banco deve estar em um estado válido antes e depois da transação.

**Isolamento** → As transações não devem interferir incorretamente entre si.

**Durabilidade** → Após o commit, os dados são persistidos de forma segura.

Exemplo prático:

Se você faz uma transferência bancária (debitar da conta A e creditar na conta B), isso precisa ser uma transação. Não pode debitar e falhar antes de creditar.

## 📚 Principais Comandos TCL

### BEGIN / START TRANSACTION

Inicia uma nova transação manualmente. 

Tudo que for executado entre BEGIN e COMMIT/ROLLBACK será tratado como uma única unidade.

```sql

BEGIN;
-- ou
START TRANSACTION;

COMMIT; -- confirma a transação
```

Confirma todas as alterações realizadas na transação atual e torna permanentes no banco.

```sql
COMMIT;
```

Exemplo:

```sql
BEGIN;
    UPDATE contas SET saldo = saldo - 100 WHERE id = 1;
    UPDATE contas SET saldo = saldo + 100 WHERE id = 2;
COMMIT;
```

Se não houver falha, os dois updates são confirmados.

## ROLLBACK

Desfaz todas as alterações realizadas na transação atual, retornando o banco ao estado anterior.

```sql
ROLLBACK;
```

Exemplo:

```sql
BEGIN;
UPDATE contas SET saldo = saldo - 100 WHERE id = 1;
-- Algo deu errado aqui
ROLLBACK;
```

👉 Nada será alterado.

## SAVEPOINT

Cria pontos de controle intermediários dentro de uma transação.
Se algo der errado, você pode voltar apenas até o ponto desejado, sem perder tudo.

```sql
BEGIN;
INSERT INTO clientes(nome) VALUES ('Carlos');

SAVEPOINT sp1;

INSERT INTO clientes(nome) VALUES ('Maria');

ROLLBACK TO sp1;  -- desfaz somente até o savepoint

COMMIT;
```

👉 O cliente "Carlos" será mantido, mas "Maria" será desfeito.

## ROLLBACK TO SAVEPOINT

Permite voltar a um ponto específico da transação sem cancelar toda ela.

```sql
ROLLBACK TO sp1;
```

## RELEASE SAVEPOINT

Remove um savepoint criado, liberando recursos.

```sql
RELEASE SAVEPOINT sp1;
```

## SET TRANSACTION

Define características da transação, como nível de isolamento.

```sql
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
```

### 🔐 Níveis de Isolamento de Transação

O PostgreSQL implementa os quatro níveis padrão do SQL:

**READ UNCOMMITTED** → Lê dados ainda não confirmados (no PostgreSQL se comporta como READ COMMITTED).

**READ COMMITTED (default)** → Só lê dados confirmados.

**REPEATABLE READ** → Garante que leituras dentro da transação não mudem.

**SERIALIZABLE** → Máxima consistência; garante que a execução seja equivalente a transações serializadas.

Exemplo:

```sql
BEGIN;
    SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    SELECT saldo FROM contas WHERE id = 1;
COMMIT;
```

## ⚙️ Exemplo Completo de Uso
Cenário: Transferência entre contas

```sql
BEGIN;

-- Debitar da conta 1
UPDATE contas SET saldo = saldo - 500 WHERE id = 1;

-- Criar savepoint
SAVEPOINT sp_transfer;

-- Creditar na conta 2
UPDATE contas SET saldo = saldo + 500 WHERE id = 2;

-- Caso ocorra erro, rollback parcial
-- ROLLBACK TO sp_transfer;

COMMIT;
```

👉 Com isso, garantimos consistência mesmo em falhas.

## Boas Práticas com TCL

- Sempre encapsule operações críticas em transações.

- Use SAVEPOINT para segurança extra em processos longos.

- Evite transações muito longas — podem causar bloqueios em tabelas.

- Prefira COMMIT explícito em vez de autocommit (mais controle).

- Ajuste o nível de isolamento de acordo com a necessidade de consistência vs desempenho.

## 🆚 Diferença entre TCL e DML

DML (INSERT, UPDATE, DELETE, SELECT) → Executa manipulação dos dados.

TCL (BEGIN, COMMIT, ROLLBACK, SAVEPOINT) → Decide se as operações de DML realmente ficam gravadas ou não.

Exemplo:

```sql
-- DML
UPDATE produtos SET preco = preco * 1.1;

-- TCL
COMMIT; -- confirma
-- ou
ROLLBACK; -- cancela
```

## ✅ Conclusão:

O TCL no PostgreSQL é a espinha dorsal que garante segurança, consistência e confiabilidade em operações críticas. Ele controla quando as alterações são confirmadas, quando podem ser revertidas e como as transações interagem entre si, sendo fundamental em qualquer aplicação corporativa que manipule dados sensíveis.