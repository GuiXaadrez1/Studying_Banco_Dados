# Introdução
Esta anotação visa deixar registrado alguns passos da resolução.

BOA PRÁTICA! Sempre na hora de buildar, olhar bem para o seu dockerfile e prestar atenção nas variáveis de ambiente e argumentos para passar as flags e comandos corretos.

## Observações:

de cara já percebemos que vamos precisar de três DockerFile, mas neste caso, vamos colocar a extensão .dockerfile

lembre-se: Na hora de criar a imagem com o build, terá que específicar com a flag -f, exemplo a baixo:

```bash
docker build -f arq.dockerfile -t meu-app .

# tag -t atribui um nome e uma tag à imagem que está sendo construída.
```

## Primeiro Passo!
Lembrando que todas as imagens a serem utilizadas estão no DockerHub

A imagem do MongoDB é pesada, afim de otimizar essa migração, vamos pegar uma imagem do aloine que é uma distribuição leve do sistema operacional linux sistema operacional e instalar o MongoDB nele.

Vamos usar as imagens oficiais do MongoDB Express e do Node


Abaixo estão todos os nossos arquivos .dockerfile

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

## Segundo passo! 
Após definir nossos dockerfile, vamos fazer o build.

```bash
# mongodb
docker build -f MongoDB.dockerfile -t mydb_mongo .
```
### listar todos os nossas imagens para verificar se a imagem foi criada 
```
docker images 
```

### Criando e executar nosso container monogodb em segundo plano
```bash
# vai ser necessário mapear a porta de forma literal, criar um volume mount
docker run -dit \
  -p 27017:27017 \
  --mount source=mydb_mongo,target=/data/db \
  --name mongodb_container \
  mydb_mongo
```

### Listando todos os nossos container ativos
```bash 
docker ps

# para ver todos os ativos e não ativados
docker container ls -a
```

### Inspecionando o nosso container e verificar qual é o endereço de ip dele
```bash
docker inspect mongodb_container
```

Isso vai retornar um arquivo JSON com as seguintes configurações:

```json
[
    {
        "Id": "90a50aa1f8cd2fd7f68dc0286fcb37a4cc99ef59d4ab571d67341f440efc537a",
        "Created": "2025-08-09T00:12:19.700828701Z",
        "Path": "mongod",
        "Args": [
            "--bind_ip",
            "0.0.0.0"
        ],
        "State": {
            "Status": "running",
            "Running": true,
            "Paused": false,
            "Restarting": false,
            "OOMKilled": false,
            "Dead": false,
            "Pid": 2854,
            "ExitCode": 0,
            "Error": "",
            "StartedAt": "2025-08-09T00:13:04.621942942Z",
            "FinishedAt": "0001-01-01T00:00:00Z"
        },
        "Image": "sha256:6bba6b65ff51da184bbee5a8c487bd64c3dc82973bcf65a0f043741a52349c0b",
        "ResolvConfPath": "/var/lib/docker/containers/90a50aa1f8cd2fd7f68dc0286fcb37a4cc99ef59d4ab571d67341f440efc537a/resolv.conf",
        "HostnamePath": "/var/lib/docker/containers/90a50aa1f8cd2fd7f68dc0286fcb37a4cc99ef59d4ab571d67341f440efc537a/hostname",
        "HostsPath": "/var/lib/docker/containers/90a50aa1f8cd2fd7f68dc0286fcb37a4cc99ef59d4ab571d67341f440efc537a/hosts",
        "LogPath": "/var/lib/docker/containers/90a50aa1f8cd2fd7f68dc0286fcb37a4cc99ef59d4ab571d67341f440efc537a/90a50aa1f8cd2fd7f68dc0286fcb37a4cc99ef59d4ab571d67341f440efc537a-json.log",
        "Name": "/mongodb_container",
        "RestartCount": 0,
        "Driver": "overlay2",
        "Platform": "linux",
        "MountLabel": "",
        "ProcessLabel": "",
        "AppArmorProfile": "",
        "ExecIDs": null,
        "HostConfig": {
            "Binds": null,
            "ContainerIDFile": "",
            "LogConfig": {
                "Type": "json-file",
                "Config": {}
            },
            "NetworkMode": "bridge",
            "PortBindings": {
                "27017/tcp": [
                    {
                        "HostIp": "",
                        "HostPort": "27017"
                    }
                ]
            },
            "RestartPolicy": {
                "Name": "no",
                "MaximumRetryCount": 0
            },
            "AutoRemove": false,
            "VolumeDriver": "",
            "VolumesFrom": null,
            "ConsoleSize": [
                30,
                120
            ],
            "CapAdd": null,
            "CapDrop": null,
            "CgroupnsMode": "private",
            "Dns": [],
            "DnsOptions": [],
            "DnsSearch": [],
            "ExtraHosts": null,
            "GroupAdd": null,
            "IpcMode": "private",
            "Cgroup": "",
            "Links": null,
            "OomScoreAdj": 0,
            "PidMode": "",
            "Privileged": false,
            "PublishAllPorts": false,
            "ReadonlyRootfs": false,
            "SecurityOpt": null,
            "UTSMode": "",
            "UsernsMode": "",
            "ShmSize": 67108864,
            "Runtime": "runc",
            "Isolation": "",
            "CpuShares": 0,
            "Memory": 0,
            "NanoCpus": 0,
            "CgroupParent": "",
            "BlkioWeight": 0,
            "BlkioWeightDevice": [],
            "BlkioDeviceReadBps": [],
            "BlkioDeviceWriteBps": [],
            "BlkioDeviceReadIOps": [],
            "BlkioDeviceWriteIOps": [],
            "CpuPeriod": 0,
            "CpuQuota": 0,
            "CpuRealtimePeriod": 0,
            "CpuRealtimeRuntime": 0,
            "CpusetCpus": "",
            "CpusetMems": "",
            "Devices": [],
            "DeviceCgroupRules": null,
            "DeviceRequests": null,
            "MemoryReservation": 0,
            "MemorySwap": 0,
            "MemorySwappiness": null,
            "OomKillDisable": null,
            "PidsLimit": null,
            "Ulimits": [],
            "CpuCount": 0,
            "CpuPercent": 0,
            "IOMaximumIOps": 0,
            "IOMaximumBandwidth": 0,
            "Mounts": [
                {
                    "Type": "volume",
                    "Source": "mydb_mongo",
                    "Target": "/data/db"
                }
            ],
            "MaskedPaths": [
                "/proc/asound",
                "/proc/acpi",
                "/proc/interrupts",
                "/proc/kcore",
                "/proc/keys",
                "/proc/latency_stats",
                "/proc/timer_list",
                "/proc/timer_stats",
                "/proc/sched_debug",
                "/proc/scsi",
                "/sys/firmware",
                "/sys/devices/virtual/powercap"
            ],
            "ReadonlyPaths": [
                "/proc/bus",
                "/proc/fs",
                "/proc/irq",
                "/proc/sys",
                "/proc/sysrq-trigger"
            ]
        },
        "GraphDriver": {
            "Data": {
                "ID": "90a50aa1f8cd2fd7f68dc0286fcb37a4cc99ef59d4ab571d67341f440efc537a",
                "LowerDir": "/var/lib/docker/overlay2/e49e8c6f03bacd75d0c60cb7280991845f5a2b9b9770fa0e217422b32b05c9b9-init/diff:/var/lib/docker/overlay2/cehlrktrznq4zsfu3n0qdemsx/diff:/var/lib/docker/overlay2/6e65add98d35aec66c513a27030787ed418557d7e4ada9ec7df441eb1770c269/diff",
                "MergedDir": "/var/lib/docker/overlay2/e49e8c6f03bacd75d0c60cb7280991845f5a2b9b9770fa0e217422b32b05c9b9/merged",
                "UpperDir": "/var/lib/docker/overlay2/e49e8c6f03bacd75d0c60cb7280991845f5a2b9b9770fa0e217422b32b05c9b9/diff",
                "WorkDir": "/var/lib/docker/overlay2/e49e8c6f03bacd75d0c60cb7280991845f5a2b9b9770fa0e217422b32b05c9b9/work"
            },
            "Name": "overlay2"
        },
        "Mounts": [
            {
                "Type": "volume",
                "Name": "mydb_mongo",
                "Source": "/var/lib/docker/volumes/mydb_mongo/_data",
                "Destination": "/data/db",
                "Driver": "local",
                "Mode": "z",
                "RW": true,
                "Propagation": ""
            }
        ],
        "Config": {
            "Hostname": "90a50aa1f8cd",
            "Domainname": "",
            "User": "",
            "AttachStdin": false,
            "AttachStdout": false,
            "AttachStderr": false,
            "ExposedPorts": {
                "27017/tcp": {}
            },
            "Tty": true,
            "OpenStdin": true,
            "StdinOnce": false,
            "Env": [
                "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
            ],
            "Cmd": [
                "mongod",
                "--bind_ip",
                "0.0.0.0"
            ],
            "Image": "mydb_mongo",
            "Volumes": {
                "/data/db": {}
            },
            "WorkingDir": "",
            "Entrypoint": null,
            "OnBuild": null,
            "Labels": {}
        },
        "NetworkSettings": {
            "Bridge": "",
            "SandboxID": "037ce4d8460afd6f3f3decb0186ff9de87349e3af1d132d57a952e1b99b9cc90",
            "SandboxKey": "/var/run/docker/netns/037ce4d8460a",
            "Ports": {
                "27017/tcp": [
                    {
                        "HostIp": "0.0.0.0",
                        "HostPort": "27017"
                    },
                    {
                        "HostIp": "::",
                        "HostPort": "27017"
                    }
                ]
            },
            "HairpinMode": false,
            "LinkLocalIPv6Address": "",
            "LinkLocalIPv6PrefixLen": 0,
            "SecondaryIPAddresses": null,
            "SecondaryIPv6Addresses": null,
            "EndpointID": "5297fc60535fa883279df8b2d4d6a3c7f3aa18e73f46f514f36634670674d2dd",
            "Gateway": "172.17.0.1",
            "GlobalIPv6Address": "",
            "GlobalIPv6PrefixLen": 0,
            "IPAddress": "172.17.0.2",
            "IPPrefixLen": 16,
            "IPv6Gateway": "",
            "MacAddress": "4a:9d:a4:0c:34:42",
            "Networks": {
                "bridge": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "MacAddress": "4a:9d:a4:0c:34:42",
                    "DriverOpts": null,
                    "GwPriority": 0,
                    "NetworkID": "9823a64207d91537fac98964991d1e90feaccef012f08d8c4e910f57df6fb3ce",
                    "EndpointID": "5297fc60535fa883279df8b2d4d6a3c7f3aa18e73f46f514f36634670674d2dd",
                    "Gateway": "172.17.0.1",
                    "IPAddress": "172.17.0.2",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "DNSNames": null
                }
            }
        }
    }
]
```

O que nos interessa é encontrar o ip do containe: 

```json
"Networks": {
                "bridge": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "MacAddress": "4a:9d:a4:0c:34:42",
                    "DriverOpts": null,
                    "GwPriority": 0,
                    "NetworkID": "9823a64207d91537fac98964991d1e90feaccef012f08d8c4e910f57df6fb3ce",
                    "EndpointID": "5297fc60535fa883279df8b2d4d6a3c7f3aa18e73f46f514f36634670674d2dd",
                    "Gateway": "172.17.0.1",
                    "IPAddress": "172.17.0.2", <-- esse é o endereço ip que nos interessa
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "DNSNames": null
                }
```

### Buildando, criando o container do mongodb express

```bash
# mongodb express

# Definindo uma Variável de Ambiente em um Sistema Operacional Linux

export MONGOIP = 172.17.0.2

# Verificando se a variável de ambiente foi criada e se está com o valor adequado

echo $MONGOIP

# em linux neste contexto, usamos o $ para acessar o valor de variáveis

# podemos fazer o seguinte também: Substituição de comandos ($(...))

# entre outras funcionalidades que vale apena a pesquisar dependendo do contexto

# Agora vamos criar a nossa imagem passando como argumento que rescebe o valor que está na Variável de Ambiente criada MONGOIP, usamos o --build-arg para isso.

docker build -f MongoExpress.dockerfile -t express_mongo --build-arg MONGO=$MONGOIP .

# praticamente a flag --build-arg, na hora de criar a imagem, vai procurar por uma variável de ambiente no nosso sistema operacional chamado de MONGOIP

# Verificando se a imagem foi criada
docker images
```

### Criando e executando o container que comportará a imagem express_mongo
```bash
docker run --name mongo_express_container \
-dit \
-p 8081:8081 \ 
express_mongo

# a barra do windows serve para quebrarmos linhas no shell do linux

# lembrando que para acessar o painel de adminstração do mongo express, você precisa colocar localhost:8081

# Veridica se o container foi criado
docker container ls -a 
```

### Criando imagem da aplicação
```bash
# basicamente a mesma coisa da imagem do mongo_express
docker build -f Application.dockerfile -t app_node --build-arg MONGO=$MONGOIP . 

# Verifica se a imagem foi gerada
docker images
```

### Criando container com a imagem app que acabamos de criar
```bash
docker run --name application_node \
-dit \
-p \
3000:3000 app_node

# Verifica se o container foi gerado
docker container ls -a 
```


### OBSERVAÇÕES

**Observação:** Veja que para cada serviço da nossa aplicação, teremos que criar um dockerfile? Então, par agerenciar tudos em um só arquivo só. Usamos o docker compose coma fomosa extensão .yaml