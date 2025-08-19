# Introdução Roles em PostgreSQL

Em PostgreSQL, uma role é um contêiner de permissões usado para gerenciar usuários e privilégios no banco de dados. Roles podem funcionar como usuários individuais ou grupos de usuários, permitindo que permissões sejam atribuídas de forma centralizada e reutilizável.

O conceito de roles é fundamental para a segurança e administração de bancos de dados, pois permite:

- Controle de acesso granular a tabelas, colunas, schemas e funções.

- Simplificação da gestão de permissões, agrupando usuários com privilégios semelhantes.

- Auditoria e rastreabilidade, identificando quais roles possuem acesso a quais recursos.

- No PostgreSQL, usuários e grupos são tratados como roles; a diferença é apenas conceitual:

- User role: role que pode fazer login (LOGIN).

- Group role: role sem permissão de login, usada para agrupar outros usuários.

## Estrutura Sintática

- Criar uma role simples (login permitido):

```sql
CREATE ROLE nome_role LOGIN PASSWORD 'senha';
```

## Criar uma role sem login (grupo)

```sql
CREATE ROLE nome_grupo NOLOGIN;
```

## Atribuir permissões a uma role

```sql
GRANT SELECT, INSERT ON tabela TO nome_role;
```

- Adicionar um usuário a um grupo:

```sql
GRANT nome_grupo TO nome_role;
```

- Revogar permissões:
```sql
REVOKE INSERT ON tabela FROM nome_role;
```

## Exemplos Práticos

- Exemplo 1 – Criar um usuário com permissões básicas:

```sql
CREATE ROLE analista LOGIN PASSWORD 'senha123';
GRANT SELECT ON clientes, vendas TO analista;
```

O usuário analista pode apenas ler dados das tabelas clientes e vendas.

- Exemplo 2 – Criar um grupo e adicionar usuários:

```sql
CREATE ROLE equipe_financeira NOLOGIN;
GRANT equipe_financeira TO analista;
GRANT equipe_financeira TO gerente;
```

O grupo equipe_financeira centraliza permissões compartilhadas entre vários usuários.

- Exemplo 3 – Atribuir privilégios de esquema:

```sql
GRANT USAGE ON SCHEMA financeiro TO equipe_financeira;
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA financeiro TO equipe_financeira;
```

Os membros do grupo podem acessar o esquema financeiro e manipular suas tabelas de acordo com os privilégios concedidos.

- Exemplo 4 – Revogar privilégios:

```sql
REVOKE UPDATE ON clientes FROM analista;
```

O usuário analista perde a permissão de atualização na tabela clientes, mantendo apenas SELECT.

## Boas Práticas

- Prefira grupos (roles sem login) para centralizar permissões comuns, evitando repetir GRANTs para cada usuário.

- Não atribua privilégios diretamente a usuários, sempre que possível, use roles-grupos.

- Use roles com LOGIN apenas quando necessário, minimizando a superfície de ataque.

- Revise regularmente as roles e permissões para evitar acessos desnecessários.

- Combine roles com schemas e views para controle de acesso mais granular.

## Aplicações Reais

- Gestão de usuários em sistemas corporativos, separando funções de analistas, gerentes e administradores.

- Criação de grupos de segurança para setores, como finanças, RH ou TI.

- Controle de acesso a dados sensíveis, garantindo conformidade com normas como LGPD ou GDPR.

- Facilitação de auditoria, permitindo rastrear ações de usuários por role.