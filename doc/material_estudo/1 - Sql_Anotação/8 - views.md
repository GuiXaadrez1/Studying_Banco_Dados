# Introdução Views em PostgreSQL

Uma View é uma tabela virtual criada a partir de uma consulta SQL. Diferente de uma tabela física, a view não armazena os dados permanentemente (exceto se for uma materialized view), mas sim o resultado de um SELECT, que é recalculado sempre que a view é consultada.

As views têm como principais objetivos:

- Simplificar consultas complexas, encapsulando lógica de joins, filtros ou agregações.

- Proteger dados sensíveis, exibindo apenas colunas necessárias aos usuários.

- Padronizar relatórios e consultas frequentes, sem duplicar código.

## Diferença entre View e Subquery/SELECT de SELECT

| Aspecto      | Subquery / SELECT de SELECT           | View                                               |
| ------------ | ------------------------------------- | -------------------------------------------------- |
| Persistência | Temporária, usada apenas na consulta  | Definida no banco, reutilizável                    |
| Reutilização | Não pode ser chamada fora da query    | Pode ser consultada em várias queries              |
| Legibilidade | Pode ser complexa em consultas longas | Simplifica consultas complexas                     |
| Performance  | Executada a cada SELECT               | Executada a cada SELECT (exceto materialized view) |
| Segurança    | Não esconde colunas                   | Pode restringir colunas e linhas                   |
| Atualizável  | Não aplicável                         | Algumas views são atualizáveis                     |

## Estrutura Sintática

- Criar uma view simples:

```sql
CREATE VIEW nome_view AS
SELECT coluna1, coluna2
FROM tabela
WHERE condicao;
```

- Criar uma view com joins:

```sql
CREATE VIEW vendas_cliente AS
SELECT c.nome AS cliente, v.id_venda, v.valor
FROM clientes c
JOIN vendas v ON c.id_cliente = v.cliente_id;
```

- Consultando uma view:

```sql
SELECT * FROM vendas_cliente
WHERE valor > 100;

Materialized View (armazenamento físico)

CREATE MATERIALIZED VIEW vendas_cliente_mv AS
SELECT c.nome AS cliente, v.id_venda, v.valor
FROM clientes c
JOIN vendas v ON c.id_cliente = v.cliente_id;
```

A materialized view armazena o resultado fisicamente e precisa ser atualizada com REFRESH MATERIALIZED VIEW quando os dados base mudam.

## Exemplos Práticos

- Exemplo 1 – View para simplificar subqueries:

```sql
CREATE VIEW clientes_ativos AS
SELECT c.id_cliente, c.nome
FROM clientes c
WHERE EXISTS (
    SELECT 1
    FROM vendas v
    WHERE v.cliente_id = c.id_cliente
);
```

Agora, qualquer query pode usar clientes_ativos sem precisar repetir a subquery.

- Exemplo 2 – View com agregação:

```sql
CREATE VIEW total_vendas_cliente AS
SELECT c.id_cliente, c.nome, COUNT(v.id_venda) AS total_vendas
FROM clientes c
JOIN vendas v ON c.id_cliente = v.cliente_id
GROUP BY c.id_cliente, c.nome;
```

Permite consultas rápidas sem reescrever o GROUP BY.

- Exemplo 3 – Materialized view para performance:

```sql
CREATE MATERIALIZED VIEW relatorio_vendas AS
SELECT c.nome AS cliente, SUM(v.valor) AS total_vendido
FROM clientes c
JOIN vendas v ON c.id_cliente = v.cliente_id
GROUP BY c.nome;

-- Atualizando a materialized view:
REFRESH MATERIALIZED VIEW relatorio_vendas;
```

Reduz carga em consultas repetitivas sobre grandes volumes de dados.

## Boas Práticas

- Use views para ocultar complexidade e reutilizar lógica de negócios.

- Prefira materialized views para relatórios pesados ou consultas frequentes.

- Combine views com aliases e CTEs para clareza em consultas complexas.

- Evite criar views desnecessárias em tabelas muito pequenas; o ganho de legibilidade pode ser mínimo.

## Aplicações Reais

- Dashboards e relatórios gerenciais com dados consolidados.

- Filtros de acesso a dados sensíveis, mostrando apenas colunas autorizadas.

- Padronização de consultas frequentes em sistemas corporativos.

- Redução de repetição de subqueries complexas ou SELECT de SELECT, tornando o código mais limpo e modular.