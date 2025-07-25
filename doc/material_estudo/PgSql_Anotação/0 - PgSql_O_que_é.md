# Introdução
Este arquivo tem como principal objetivo compreender o conceito da linguagem de programação postgreSql, como criar um arquivo com extensão .pspgsql, para que serve, sintaxe básica e etc...

## ✅ O que é PL/pgSQL?

**PL/pgSQL** (*Procedural Language/PostgreSQL SQL*) é a **linguagem procedimental padrão do PostgreSQL**.

- É uma extensão da **SQL tradicional**.
- Permite criar **funções, triggers e procedimentos armazenados** com lógica de programação.

- Você pode usar **variáveis, condicionais (IF)**, laços (**FOR, WHILE**), tratamento de erros (**EXCEPTION**) — recursos **que SQL puro não tem**.

- Ela incorpora à SQL, características procedurais como benefícios e falicidades de controle de fluxo de programas que asa molhores linguagens possuem.

---

## O que é uma linguagem procedural?

definição:

  Uma linguagem procedural (ou procedimental) é um paradigma de programação que organiza o código em procedimentos, rotinas ou funções, que são sequências de instruções executadas passo a passo.

**Características principais:**

Fluxo de controle explícito:

- Você define exatamente a sequência de passos — início, processa, fim.

Estruturas básicas:

- Variáveis, comandos de entrada/saída, condicionais (if), laços (for, while).

Abstração em funções:

- Problemas grandes são quebrados em funções/sub-rotinas.

Estado global ou local:

- Variáveis podem ser globais (mais acopladas) ou locais (mais controladas).

**Exemplos de linguagens procedurais:**

C → Clássico: puro procedural.

Pascal → Muito usado para ensino.

BASIC → Clássico dos anos 80/90.

PL/pgSQL (dentro do PostgreSQL) → Procedimentos armazenados.

Python → Suporta procedural e orientado a objetos (multi-paradigma).

C++ → Também suporta procedural (antes da POO).

## O que é uma linguagem Orientada a Objetos?

Uma linguagem Orientada a Objetos é uma linguagem de programação baseada no paradigma da Programação Orientada a Objetos (POO) — em inglês, OOP (Object-Oriented Programming).

👉 POO = OOP. É exatamente a mesma coisa, só muda o idioma:

(🇧🇷) POO → Programação Orientada a Objetos (termo em português)

(🇺🇸) OOP → Object-Oriented Programming (termo original em inglês)

No mercado global, você vai ver OOP em documentações, livros e frameworks. Em materiais em português, é mais comum POO.

**📌 Princípio fundamental:**

O paradigma orientado a objetos modela um sistema como um conjunto de objetos que interagem.

Objeto = entidade que representa algo do mundo real, tendo:

Atributos (dados, estado)
Ex.: nome, saldo, cor.

Métodos (funções, comportamentos)
Ex.: depositar(), acelerar(), ligar().

**🧩 Principais conceitos (os “4 pilares” da POO):**

1️⃣ Encapsulamento

Dados + comportamento ficam juntos no mesmo objeto.

Você protege detalhes internos.

Exemplo: classe ContaBancaria tem saldo privado, acessível só por depositar() ou sacar().

2️⃣ Herança

Permite reaproveitar código criando novas classes baseadas em outras.

Exemplo: Cachorro herda de Animal.

3️⃣ Polimorfismo

Objetos diferentes podem usar a mesma interface, mas com comportamentos diferentes.

Exemplo: Desenhar() funciona diferente em Círculo e Quadrado.

4️⃣ Abstração

Você simplifica sistemas complexos, mostrando só o essencial.

Exemplo: classe Carro esconde complexidade do motor — expõe ligar(), acelerar().

**✅ Exemplos de linguagens orientadas a objetos:**

Java (100% OO)

C# (.NET)

Python (multi-paradigma, mas POO forte)

Ruby

C++ (híbrido: procedural + POO)

JavaScript (tem POO via protótipos e classes modernas)

## Qual é a diferença de uma linguagem procedimental para orientada a objeto (POO)?

**⚖️ Paradigma procedural**

- Foco: O fluxo da execução.

- Modelo mental: “O que fazer primeiro? O que fazer depois?”

- Exemplo: Você escreve funções como abrirArquivo(), processarDados(), salvarArquivo().

- Organização: Código agrupado em funções e módulos.

**🧩 Paradigma Orientado a Objetos (OOP/POO):**

- Foco: Modelar o mundo real como objetos.

- Modelo mental: Tudo é um objeto com estado (atributos) e comportamento (métodos).

Exemplo:

  Você tem uma classe Carro com propriedades cor, modelo e métodos acelerar(), frear().

  Principais conceitos:

  Encapsulamento: Dados e comportamento juntos.

  Herança: Especialização de classes.

  Polimorfismo: Mesma interface, comportamentos diferentes.

  Abstração: Esconde detalhes de implementação.

**Resumo da diferença:**

| Aspecto         | Procedural                      | Orientado a Objetos              |
| --------------- | ------------------------------- | -------------------------------- |
| **Foco**        | Funções/rotinas                 | Objetos                          |
| **Abstração**   | Fluxo de instruções             | Estado + comportamento           |
| **Reuso**       | Funções reutilizáveis           | Classes e herança                |
| **Organização** | Programas lineares ou modulares | Estruturas de classes/instâncias |
| **Exemplo**     | `processarPedido()`             | `Pedido.processar()`             |

**Quando usar cada um:**

| Quando usar procedural            | Quando usar POO                        |
| --------------------------------- | -------------------------------------- |
| Scripts simples                   | Aplicações complexas                   |
| Lógicas de banco (ex: triggers)   | Modelagem de domínio complexo          |
| Programas que seguem fluxo linear | Sistemas com muitos tipos de entidades |


**No caso do PL/pgSQL:**

Você usa procedural porque trabalha dentro do banco, criando funções e triggers para executar fluxos automáticos.

PostgreSQL não implementa POO dentro do PL/pgSQL — mas você pode usar conceitos de encapsulamento dentro das funções, se quiser.

**Por que é uma linguagem *procedural*?**

- Porque **controla o fluxo de execução passo a passo**, como uma linguagem de programação (ex: Python, C).

- SQL **normal** é **declarativo** → você descreve *o que* quer.

- PL/pgSQL é **procedural** → você descreve *como* fazer: passo a passo.

**Exemplo simples de procedural:**  
```sql
BEGIN
  IF condição THEN
    -- faz algo
  ELSE
    -- faz outra coisa
  END IF;
END;
```

## Onde o PL/pgSQL roda?
Dentro do servidor PostgreSQL -> (psql: Servidor local do Postgres).

Você não executa PL/pgSQL direto no terminal como um script shell.

Você cria funções/rotinas no banco — e invoca via SELECT.

## 📂 Como criar arquivos .plpgsql

Você pode organizar seus scripts PL/pgSQL em arquivos com extensão .plpgsql (ou .sql — ambos funcionam).


### 📌 Exemplos

No Linux, Git Bash ou WSL:

```bash
touch criar_funcao.plpgsql
```
No PowerShell (Windows):

```powershell
New-Item -Name "criar_funcao.plpgsql" -ItemType "File"
```
No CMD (Prompt):

```cmd
type nul > criar_funcao.plpgsql
```

## 📜 Conteúdo de um arquivo .plpgsql

```sql
-- criar_funcao.plpgsql

-- Cria uma função que imprime uma mensagem no log do banco
CREATE OR REPLACE FUNCTION diga_ola()
RETURNS void AS $$
BEGIN
  RAISE NOTICE 'Olá, PL/pgSQL está funcionando!';
END;
$$ LANGUAGE plpgsql;
```
## ⚡ Como executar o arquivo no PostgreSQL

1️⃣ Abra o terminal psql:

```bash
psql -U seu_usuario -d seu_banco
```

2️⃣ Execute o arquivo:

```
\i criar_funcao.plpgsql
```
ou use o terminal shell:

```bash
psql -U seu_usuario -d seu_banco -f criar_funcao.plpgsql
```

3️⃣ Rode a função:

```sql
SELECT diga_ola();
```

🔍 Resultado:

```bash
NOTICE:  Olá, PL/pgSQL está funcionando!
```

**💡 Boas práticas para repositórios:**

```graphql
📂 sql/
 ├── schema.sql           # Tabelas
 ├── functions.plpgsql    # Funções em PL/pgSQL
 ├── triggers.plpgsql     # Triggers em PL/pgSQL
 ├── views.sql            # Views
 ├── seeds.sql            # Inserts iniciais
```
Versione tudo no Git.

Nunca suba credenciais.

Scripts são infraestrutura como código → devem ter histórico.

## 🟢 Resumo

✅ PL/pgSQL é a linguagem procedural do PostgreSQL, ideal para regras de negócio complexas dentro do banco.

✅ Você cria funções e triggers, salva em arquivos .plpgsql (ou .sql) e executa com psql.

✅ Mantenha tudo versionado para rastrear evolução do schema e lógica.

Pronto! Qualquer dúvida, rode este guia, teste no seu banco — e ajuste conforme suas rotinas.
