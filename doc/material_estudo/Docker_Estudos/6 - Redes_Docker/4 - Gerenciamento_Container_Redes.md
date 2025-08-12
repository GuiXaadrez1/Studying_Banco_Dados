# Introdução

No gerenciamento de redes Docker, além de criar redes personalizadas, é fundamental controlar a conexão dos containers a essas redes. Um container pode ser conectado a múltiplas redes, permitindo arquiteturas de comunicação complexas.

Este capítulo detalha os comandos, flags e práticas para conectar, desconectar e modificar containers em redes Docker.

## Criando containers em redes específicas

Ao criar um container, você pode definir a rede que ele irá utilizar com a flag:

```bash
--network nome_da_rede
```

Exemplo:

```bash
docker run -dit --name meu_container --network minha_rede imagem
```

Neste caso:

-d executa o container em background (segundo plano).

-i mantém STDIN aberto.

-t aloca um pseudo-terminal.

--network minha_rede conecta o container à rede minha_rede.

## Conectando um container existente a uma rede
Para conectar um container que já está rodando (ou parado) a uma nova rede:

```bash
docker network connect nome_da_rede nome_container
```

Exemplo:

```bash
docker network connect minha_rede meu_container
```

Isso adiciona o container à rede minha_rede sem reiniciar o container.

## Desconectando um container de uma rede

Para remover a conexão de um container com uma rede específica:

```bash
docker network disconnect nome_da_rede nome_container
```

Exemplo:

```bash
docker network disconnect minha_rede meu_container
```

### Observações importantes:

- Se o container estiver conectado a várias redes, ele permanecerá acessível pelas outras.

- Se desconectar o container da única rede que ele possui, ele ficará isolado da rede.

## Comandos úteis para gerenciamento

### Listar redes do container

```bash
docker inspect -f '{{json .NetworkSettings.Networks}}' nome_container | jq
```
Retorna um JSON com as redes conectadas ao container, facilitando o diagnóstico.

## Exemplo prático
```bash
# Criar rede personalizada
docker network create minha_rede

# Criar container conectado a essa rede
docker run -dit --name app1 --network minha_rede alpine sh

# Criar container conectado à rede padrão bridge
docker run -dit --name app2 alpine sh

# Conectar app2 na rede minha_rede
docker network connect minha_rede app2

# Verificar redes de app2
docker inspect -f '{{json .NetworkSettings.Networks}}' app2 | jq

# Desconectar app2 da rede bridge padrão
docker network disconnect bridge app2
```

## Comunicação entre containers em múltiplas redes

Containers conectados a múltiplas redes podem rotear tráfego entre elas, o que permite arquiteturas segmentadas e segmentação por redes.

Exemplo: Um container conectado a uma rede front_end e outra back_end pode atuar como proxy ou firewall entre redes.

## Modificando variáveis de ambiente para comunicação

Antes, para comunicar containers, era comum usar variáveis de ambiente com IPs fixos:

```dockerfile
ARG MONGOIP=172.17.0.2
ENV ME_CONFIG_MONGODB_SERVER=$MONGOIP
```

Limitação: IPs mudam após reinício, causando falhas.

## Melhoria com redes personalizadas

Em redes personalizadas, use nome do container para comunicação:

```dockerfile
ENV ME_CONFIG_MONGODB_SERVER=mydb_mongo
```

Assim, o Docker resolve automaticamente o nome mydb_mongo para o IP correto.

## Considerações avançadas

Conectar e desconectar redes em containers em produção exige atenção para evitar interrupção.

Para containers que usam rede host, não é possível conectar redes adicionais.

Em ambientes orquestrados (Docker Swarm, Kubernetes), o gerenciamento de rede é diferente e mais complexo.

## Resumo

A flag --network conecta o container a uma rede específica na criação.

docker network connect e docker network disconnect permitem gerenciar redes em containers já criados.

Containers podem estar em múltiplas redes simultaneamente, aumentando a flexibilidade.

Uso de nomes de container para comunicação é mais robusto do que uso de IPs fixos.

Atenção ao desconectar containers para evitar isolamento não intencional.