✅ Diferença básica
Conceito	Function	Stored Procedure
Definição	Função: sempre retorna um valor (ou tabela) e pode ser usada dentro de SELECTs.	Procedimento armazenado: executa um bloco de comandos, pode ou não retornar algo — foco em efeitos colaterais (inserir, atualizar, deletar).
Uso típico	Lógica computacional ou consulta reutilizável.	Automatizar tarefas, scripts administrativos, lógica de negócios mais complexa.
Pode ser chamada em SELECT?	✅ Sim!	❌ Não.
Retorno obrigatório?	✅ Sim.	❌ Não.
Chamada	SELECT minha_funcao();	CALL meu_procedimento();

✅ 1️⃣ Função (FUNCTION)
Tem entrada, processa e sempre devolve algo: escalar (1 valor), conjunto de linhas (table function) ou um tipo customizado.

Pode ser usada em SELECT, WHERE, JOIN, ou dentro de expressões.

Exemplo típico: Função de cálculo (get_imposto(), calcular_desconto()).

📌 Exemplo

sql
Copiar
Editar
CREATE OR REPLACE FUNCTION soma(a INT, b INT)
RETURNS INT AS $$
BEGIN
   RETURN a + b;
END;
$$ LANGUAGE plpgsql;

-- Chama dentro de SELECT
SELECT soma(5, 3);
✅ 2️⃣ Stored Procedure (PROCEDURE)
Focada em tarefa procedural maior, geralmente com efeito colateral: INSERT, UPDATE, DELETE, controle de transações (BEGIN, COMMIT).

Não retorna valor obrigatoriamente, pode usar OUT parameters ou RETURN sem valor.

É chamada com CALL, não pode usar dentro de SELECT.

Serve para automação administrativa, exemplo: criar backup, limpar registros, gerenciar batch jobs.

📌 Exemplo

sql
Copiar
Editar
CREATE OR REPLACE PROCEDURE limpa_clientes_inativos()
LANGUAGE plpgsql
AS $$
BEGIN
   DELETE FROM clientes WHERE ativo = false;
END;
$$;

-- Chama assim:
CALL limpa_clientes_inativos();
✅ 3️⃣ Diferença técnica no PostgreSQL
Funções (FUNCTION) existem desde sempre no PostgreSQL.
Stored Procedures (PROCEDURE) foram introduzidas só no PostgreSQL 11 — antes, tudo era função!

Por que criaram PROCEDURE?
Porque:

PROCEDURE permite CALL com transações independentes (BEGIN, COMMIT, ROLLBACK) dentro do corpo.

FUNCTION não pode abrir transações — herda a transação de quem chamou.

✅ Tabela comparativa resumida
Function	Procedure
Retorna valor	Sim (obrigatório)	Não obrigatório
Usar em SELECT	Sim	Não
Usa CALL	Não	Sim
Transações independentes	Não	Sim
Foco	Cálculo, consulta	Tarefas complexas, manutenção

🎯 Quando usar cada uma?
Quero...	Use
Calcular um valor e usar em SELECT	FUNCTION
Retornar uma tabela	FUNCTION
Fazer UPDATE/DELETE em lote	PROCEDURE
Rodar scripts de manutenção	PROCEDURE
Preciso de controle de transações internas	PROCEDURE

✅ Resumo do consultor
Função (FUNCTION):
🔍 Foco em computar e devolver resultado, reutilizável em qualquer query.

Procedure (PROCEDURE):
🔧 Foco em executar operações no banco, não se mistura em SELECT, serve pra ações.