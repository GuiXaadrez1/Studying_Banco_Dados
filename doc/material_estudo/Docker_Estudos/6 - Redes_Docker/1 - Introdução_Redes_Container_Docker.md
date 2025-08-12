# Introdução

No mundo dos containers, um dos pontos centrais para o funcionamento de aplicações distribuídas é a comunicação entre serviços. Essa comunicação só é possível por meio de redes — sejam elas criadas automaticamente pelo Docker ou configuradas manualmente pelo desenvolvedor.

O Docker, por padrão, já cria e gerencia redes internas para que containers possam se comunicar de forma segura e isolada. Isso é fundamental para manter:

- Isolamento entre ambientes diferentes

- Segurança contra acessos não autorizados

- Flexibilidade na configuração de comunicação

Quando trabalhamos com redes no Docker, precisamos entender que containers são efêmeros:

    Eles nascem, executam suas tarefas e morrem. A cada reinício, um container pode receber um novo endereço IP, pois o Docker atribui endereços dinamicamente dentro do intervalo configurado para aquela rede.

Observação: Este comportamento é análogo ao funcionamento do DHCP (Dynamic Host Configuration Protocol) em redes tradicionais, onde o servidor gerencia a atribuição de IPs para os dispositivos conectados.

### Efemeridade e Endereçamento IP no Docker

O IP de um container pode mudar entre reinicializações, o que significa que:

- Referenciar containers pelo IP diretamente não é uma prática confiável.

- É recomendável usar nomes de container (resolução DNS interna do Docker) para comunicação.

Exemplo prático de problema:

- Você cria um container app1 na rede padrão.

- Ele recebe o IP 172.17.0.2.

- Você conecta outro container db1 usando esse IP.

- Reinicia app1 e o novo IP vira 172.17.0.3.

- A conexão quebra, pois o endereço não é mais válido.

Conclusão: Sempre que possível, use nomes de containers e redes personalizadas para estabilidade.


## Redes Disponíveis no Docker

Por padrão, o Docker oferece três redes principais para containers:

| Rede       | Driver   | Descrição                                                                                       |
| ---------- | -------- | ----------------------------------------------------------------------------------------------- |
| **bridge** | `bridge` | Rede privada criada no host, conectando containers entre si e permitindo saída para a internet. |
| **host**   | `host`   | Compartilha diretamente a pilha de rede do host, sem isolamento.                                |
| **none**   | `null`   | Nenhuma rede conectada; o container fica isolado de qualquer interface de rede.                 |


### Listando todos os tipos de redes disponibilizadas pelo docker aos seus containers
```bash
docker network ls
```

### Saida esperada

```bash
NETWORK ID     NAME      DRIVER    SCOPE
9823a64207d9   bridge    bridge    local
221a3eadb331   host      host      local
c8b655a2f94f   none      null      local

# Lembre-se de usar o comando inspecionar para obter mais informações do container e das suas redes
```

```bash
docker inspect nome_container
```

No JSON retornado, a seção "Networks" contém informações como:

Nome da rede

Gateway

Endereço IP

Máscara de sub-rede

Configuração IPv6 (se habilitado)

Exemplo:

```json
"Networks": {
                "bridge": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "MacAddress": "",
                    "DriverOpts": null,
                    "GwPriority": 0,
                    "NetworkID": "9823a64207d91537fac98964991d1e90feaccef012f08d8c4e910f57df6fb3ce",
                    "EndpointID": "",
                    "Gateway": "",
                    "IPAddress": "",
                    "IPPrefixLen": 0,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "DNSNames": null
                }
            }
```

Nota: Na rede bridge padrão, o Docker gerencia IPs automaticamente via IPAM (IP Address Management).

## Tipos de Redes no Docker

A rede bridge é a rede privada padrão criada pelo Docker no momento da instalação.
Quando um container é iniciado sem especificar uma rede, ele é automaticamente conectado à rede bridge.

Funcionamento interno:

- O Docker cria uma interface virtual chamada docker0 no host.

- Essa interface atua como um switch virtual, conectando todos os containers da rede bridge.

- O Docker executa NAT (Network Address Translation) para que containers possam acessar a internet.

- Containers nessa rede podem se comunicar entre si usando IPs internos ou nomes de container.

📌 Analogia: Pense na rede bridge como um "roteador interno" exclusivo para os containers.

### inspecionando específicamente um rede do Docker
```bash
docker network inspect brigde

# vai retornar um arquivo de configuração json específica desta rede com todas as informações necessárias 
```

### Saida resumida
```json
// Todas as informações assim que inspecionamos a rede brigde
[
    {
        "Name": "bridge",
        "Id": "9823a64207d91537fac98964991d1e90feaccef012f08d8c4e910f57df6fb3ce",
        "Created": "2025-08-07T20:26:28.663896536-03:00",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv4": true,
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": null,
            "Config": [
                {
                    "Subnet": "172.17.0.0/16",
                    "Gateway": "172.17.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {},
        "Options": {
            "com.docker.network.bridge.default_bridge": "true",
            "com.docker.network.bridge.enable_icc": "true",
            "com.docker.network.bridge.enable_ip_masquerade": "true",
            "com.docker.network.bridge.host_binding_ipv4": "0.0.0.0",
            "com.docker.network.bridge.name": "docker0",
            "com.docker.network.driver.mtu": "1500"
        },
        "Labels": {}
    }
]
```

Interpretação:

- Subnet: 172.17.0.0/16 → Intervalo de IPs internos disponíveis.

- Gateway: 172.17.0.1 → IP da interface docker0.

- Driver: bridge → Define o modo de funcionamento.

### Caso de uso

Aplicações multi-container que precisam conversar entre si.

Cenários de desenvolvimento onde containers simulam um ambiente isolado.

### Limitações

Containers só podem se comunicar com outros containers da mesma rede.

A resolução de nomes (DNS interno) só funciona em redes personalizadas, não na bridge padrão.

## Rede Host 

A rede host elimina a camada de rede virtual do Docker, fazendo com que o container compartilhe a mesma pilha de rede do host.

Funcionamento interno:

- Não há NAT ou ponte de rede.

- O container usa diretamente o IP e portas do host.

- Baixa latência e melhor desempenho para serviços que precisam de alta velocidade de rede.

### Craindo container na rede host
```bash
docker run --name meu_container --network host imagem
```
Efeitos:

- Qualquer porta exposta pelo container estará diretamente disponível no IP do host.

- Dois containers na rede host não têm isolamento de rede.

### Caso de uso

Serviços que precisam de alto desempenho de rede.

Aplicações que precisam anunciar o IP real do host.

Quando a comunicação entre container e host precisa ser direta.

### Limitações e riscos

Perda total do isolamento de rede.

Potencial de conflitos de porta com serviços do host.

Maior risco de segurança.

## Rede None

A rede none desconecta completamente o container de qualquer rede, atribuindo apenas a interface de loopback (lo).

### Funcionamento interno:

Nenhuma comunicação externa é possível.

Ideal para containers que executam tarefas completamente offline ou que usam comunicação apenas via volumes compartilhados.

### Craindo um container na rede none
```bash
docker run --name container_isolado --network none imagem
```
### Caso de uso

Processamento batch totalmente offline.

Testes de segurança onde não se quer tráfego de rede.

### Limitações
Sem acesso à internet.

Sem comunicação com outros containers.

## Comparativo entre redes padrão do Docker

| Característica                      | Bridge                          | Host              | None                  |
| ----------------------------------- | ------------------------------- | ----------------- | --------------------- |
| Isolamento de rede                  | Alto                            | Baixo             | Máximo (desconectado) |
| Acesso à internet                   | Sim (via NAT)                   | Sim (direto)      | Não                   |
| Resolução de nomes entre containers | Parcial (somente personalizada) | Não aplicável     | Não                   |
| Desempenho de rede                  | Médio                           | Alto              | Não aplicável         |
| Segurança                           | Alta                            | Baixa             | Muito alta            |
| Uso típico                          | Ambientes isolados              | Desempenho máximo | Execução offline      |

## Criando redes no Docker
 
É possível realizar conexão e comunicação entre dois container, tanto pelo ip como pelo nome do container, para temos certeza disso, basta fazer um ping de um para outro, para isso é necesário criar uma rede própria e personalizada.

### Criando um rede nova na brigde
```bash
docker network create --driver brigde nome_da_sua_rede
```

### Desconectando um container de uma rede
```bash
docker network disconnect brigde nome_container
```

### Desconectando um container de uma rede específica ou personalizada
```bash
#
docker run -dit --network nome_da_rede nome_imagem

# a flag --network serve para justamente conectarmos um novo container a uma rede específica
```

### Aplicando modificações na Rede
Antes para fazermos a conexão, comunicação entre dois container, criavamos uma variável de ambiente local no nosso host que apontava para o ip do nosso container, com a craidação de uma rede personalizada, não iriamos mas passar o ip como argumento com o nome da variável de ambiente local. basta passarmos o nome do nosso container da forma que vamos fazer agora.

### ANTES
```dockerfile

# MongoDB

# instalando a distribuição linux alpine 
FROM alpine:3.9

# instalando o mongo db no nosso container
RUN apk add --no-cache mongodb 

# informando a porta que o container irá executar o mongo db
EXPOSE 27017

# Criando um volume (persistência de dados, informação do container para o nosso docker host)
VOLUME /data/db

# Liberando a requisição para todas asa máquinas da rede
CMD ["mongod", "--bind_ip","0.0.0.0"]

```

```dockerfile
# Mongo Express

FROM mongo-express:0.54

EXPOSE 8081

# Craidno argumentos para a nossa variável de ambiente que será o ip do nosso server
ARG MONGO=$MONGOIP

# Passando argumeto para nossa variável de ambiente, o $ serve apra puxar informações em 
# argumentos e variáveis de ambiente já existentes no container

# LEMBRE-SE NÃO PODE HAVER ESPAÇO NA HORA DE DEFINIR VARIÁVEIS DE AMBIENTE
ENV ME_CONFIG_MONGODB_SERVER=$MONGO

ENV ME_CONFIG_MONGODB_PORT=27017
```

```dockerfile

# APLICAÇÃO

# instalando node.js + distribuição alpine
FROM node:20.3.0-alpine3.18

# definindo o nosso diretório de aplicação
WORKDIR /application/src/modules/curso-docker-essencial-user-registration/user-registration

# fazenod uma argumento que capita o ip da variável de ambiente host
ARG MONGO
ENV MONGODB=$MONGO

# Informando em qual porta o node vai escutar eventos
EXPOSE 3000

# Copiando o nosso package-lock.json da máquina local (host) para o container
COPY doc/material_estudo/Docker_Estudos/exercicios/curso-docker-essencial-user-registration/user-registration/package-lock.json .

# Copiando o nosso package.json da máquina local (host) para o container
COPY doc/material_estudo/Docker_Estudos/exercicios/curso-docker-essencial-user-registration/user-registration/package.json .

# Copiando o restante do código individualmente
COPY doc/material_estudo/Docker_Estudos/exercicios/curso-docker-essencial-user-registration/user-registration/public .

COPY doc/material_estudo/Docker_Estudos/exercicios/curso-docker-essencial-user-registration/user-registration/views .

COPY doc/material_estudo/Docker_Estudos/exercicios/curso-docker-essencial-user-registration/user-registration/app.js  .

# indo para o diretório que contém o package.json
# RUN cd application/src/modules/curso-docker-essencial-user-registration/user-registration

# instalando depedências que podem ser necessárias
RUN apk add --no-cache python3 make g++

# instalando todas as libs necessárias do nosso packager json
RUN npm install

# executando no cmd
CMD ["node","app.js"]
```

### Depois
Vamos manter o dockerfile do MangoDB e modificar o restante

```dockerfile
# Mongo Express

FROM mongo-express:0.54

EXPOSE 8081

# LEMBRE-SE NÃO PODE HAVER ESPAÇO NA HORA DE DEFINIR VARIÁVEIS DE AMBIENTE
# Colcoando o nome do nosso container para realizar conexão
ENV ME_CONFIG_MONGODB_SERVER=mydb_mongo

ENV ME_CONFIG_MONGODB_PORT=27017
```

```dockerfile

# APLICAÇÃO

# instalando node.js + distribuição alpine
FROM node:20.3.0-alpine3.18

# definindo o nosso diretório de aplicação
WORKDIR /application/src/modules/curso-docker-essencial-user-registration/user-registration

# passando o nome do nosso container
ENV MONGODB=mydb_mongo

# Informando em qual porta o node vai escutar eventos
EXPOSE 3000

# Copiando o nosso package-lock.json da máquina local (host) para o container
COPY doc/material_estudo/Docker_Estudos/exercicios/curso-docker-essencial-user-registration/user-registration/package-lock.json .

# Copiando o nosso package.json da máquina local (host) para o container
COPY doc/material_estudo/Docker_Estudos/exercicios/curso-docker-essencial-user-registration/user-registration/package.json .

# Copiando o restante do código individualmente
COPY doc/material_estudo/Docker_Estudos/exercicios/curso-docker-essencial-user-registration/user-registration/public .

COPY doc/material_estudo/Docker_Estudos/exercicios/curso-docker-essencial-user-registration/user-registration/views .

COPY doc/material_estudo/Docker_Estudos/exercicios/curso-docker-essencial-user-registration/user-registration/app.js  .

# indo para o diretório que contém o package.json
# RUN cd application/src/modules/curso-docker-essencial-user-registration/user-registration

# instalando depedências que podem ser necessárias
RUN apk add --no-cache python3 make g++

# instalando todas as libs necessárias do nosso packager json
RUN npm install

# executando no cmd
CMD ["node","app.js"]
```

Tiramos os argumentos, pois não iremos mais precisar criar uma variável de ambiente na nossa máquina host contendo o ip do container, agora vamos passa o nome do container

## Agora que fazemos após essa modificação?
- Criamos a nossa rede com brigde
- Fazemos o build de cada imagem
- Criamos e executamos na nossa rede personalizada com:
```bash
docker run --name nome_container -dit --network nome_rede_personalizada_criada -p porta_host:porta_container nome_imagem_container

# -p se necessário, nesta caso é necessário.
```

## Conhecendo redes Host e None

Rede Host é a rede do seu docker host, basicamente a rede da nossa máquina
```bash
docker run --name nome_container:nome_tag_container -dit --network host 
```

Rede None: é a rede que não está relacionada, atrelada a nem uma interface de rede
```bash 
docker run --name nome_container:nome_tag_container -dit --network none nome_imagem_container
```

