# Introdução

Este documento tem como objetivo explicar o que é mapeamento de portas, o que são portas lógicas (no contexto de redes e sistemas), para que servem e como funcionam, especialmente no uso com Docker, servidores e ambientes de desenvolvimento.

---

## O que são Portas?

Em redes de computadores, **portas** são canais lógicos identificados por números que vão de `0` a `65535`, responsáveis por direcionar o tráfego de dados entre um host (como um computador ou container) e um serviço específico.

- As **portas bem conhecidas** vão de `0` a `1023` (ex: 22 - SSH, 80 - HTTP, 443 - HTTPS).
- As **portas registradas** vão de `1024` a `49151`.
- As **portas dinâmicas/privadas** vão de `49152` a `65535`.

---

## Para que Servem?

Portas permitem que um mesmo IP (máquina) possa rodar múltiplos serviços simultaneamente. Por exemplo:

- Um banco de dados PostgreSQL roda normalmente na porta `5432`.
- Um servidor web Apache pode rodar na `80`.
- Uma aplicação Node.js pode usar a `3000`.

Sem portas, seria impossível saber para qual serviço direcionar o tráfego recebido pelo IP.

---

## O que é Mapeamento de Portas?

**Mapeamento de portas** é o processo de fazer uma ponte entre uma porta externa (visível para o usuário ou sistema que está acessando) e uma porta interna (onde o serviço realmente está rodando).

### Exemplo com Docker:

```bash
docker run -p 5431:5432 postgres
```

- O -p realiza o mapeamento.

- O primeiro 5431 é a porta externa (host/local).

- O segundo 5432 é a porta interna (container).

Isso significa: qualquer conexão feita para a porta 5432 da máquina host será redirecionada para a porta 5432 do container onde o PostgreSQL está rodando.

## O que é um host? 

Um host, em termos de redes de computadores, é o nome de dispositivo conectado, que utiliza serviços e recursos. Quando perguntamos o que é host, temos uma resposta abrangente: pode ser um servidor, um computador, um celular ou qualquer dispositivo conectado. Cada host possui um endereço IP exclusivo, que o identifica na rede.

Além disso, um host sempre representa um endereço IP associado a ele. Os hosts são responsáveis por processar solicitações, fornecer serviços e facilitar a comunicação entre dispositivos em uma rede.

Em resumo, um host é qualquer máquina que recebe, armazena ou compartilha dados em uma rede, tornando possível o funcionamento da internet e a comunicação entre dispositivos.


## Como Funciona?

Internamente, o sistema operacional gerencia uma tabela de roteamento de pacotes por meio de endereço IP + porta. Quando você faz uma requisição, como:

```bash
psql -h localhost -p 5432 -U postgres

# -h é o nosso host, -p é a porta mapeada, -U é o usuário 
```

O sistema operacional:

- Resolve o localhost como 127.0.0.1. (host)

- Verifica a porta 5432.

- Redireciona o tráfego para o processo que "escutou" essa porta (ex: PostgreSQL ou container).


## Mapemaento de portas com o container Docker

**Lembre-se:** O container por padrão é um serviço idependente e isolados dos serviços da máquina host. Logo, o mapeamento de portas no Docker serve para expor portas do container para serem acessadas a partir da máquina host, o que é essencial quando você quer que um serviço rodando dentro do container (como PostgreSQL, uma API, etc.) possa ser acessado externamente.

### 📌 Sintaxe do mapeamento de portas

A opção usada no comando docker run é:

```bash
-p <porta_host>:<porta_container>
```

### ✅ Exemplo básico
Se você está rodando um container que expõe a porta 5432 (como o PostgreSQL), e quer acessá-lo da sua máquina:

```bash
docker run -d -p 5432:5432 nome_da_imagem
```

Isso faz com que:

- 5432 da máquina host (sua máquina) seja redirecionado para

- 5432 dentro do container

### ✅ Exemplo com porta personalizada
Você pode mudar a porta externa para evitar conflitos locais:

```bash
docker run -d -p 15432:5432 nome_da_imagem
```

Agora, o PostgreSQL (que escuta na 5432 internamente) poderá ser acessado na porta 15432 da sua máquina host:

```bash
psql -h localhost -p 15432 -U postgres
```

### ✅ Usando docker-compose
Em um docker-compose.yml, o mapeamento é feito com ports:

```yaml
services:
  db:
    image: postgres:14
    ports:
      - "15432:5432"
```

## Portas no Docker e Desenvolvimento

Container com múltiplos serviços

Se você quiser rodar dois containers que usam a mesma porta interna, deve mapear para portas externas diferentes:

```bash
docker run -p 5432:5432 postgres # Primeiro container
docker run -p 5433:5432 postgres # Segundo container
```

Assim você pode acessar:

    Banco 1: localhost:5432

    Banco 2: localhost:5433

## Considerações de Segurança

Evite expor portas desnecessárias para o público.

Use firewall e iptables para limitar acessos.

Use redes privadas do Docker (docker network) para isolar containers.

## Conclusão

O mapeamento de portas é fundamental para o funcionamento de aplicações modernas, containers e servidores. Compreender o uso e a configuração correta dessas portas garante segurança, flexibilidade e escalabilidade em ambientes de desenvolvimento e produção.