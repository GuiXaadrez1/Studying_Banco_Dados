# Introdução

Objetivo. Entender o funcionamento interno das redes do Docker exige a habilidade de inspecionar tanto os containers quanto as redes criadas. O comando fundamental para isso é:

```bash
docker inspect <objeto>
```

Onde <objeto> pode ser o nome ou ID de um container, imagem, rede ou volume.

### Comando básico:

```bash
docker inspect nome_container
```
Retorna um documento JSON extenso com todas as informações do container. Informações relevantes para redes na saída JSON, a seção de interesse é:

```json
"NetworkSettings": {
    "Networks": {
        "nome_rede": {
            "IPAMConfig": null,
            "Links": null,
            "Aliases": null,
            "MacAddress": "02:42:ac:11:00:02",
            "NetworkID": "id_da_rede",
            "EndpointID": "id_do_endpoint",
            "Gateway": "172.17.0.1",
            "IPAddress": "172.17.0.2",
            "IPPrefixLen": 16,
            "IPv6Gateway": "",
            "GlobalIPv6Address": "",
            "GlobalIPv6PrefixLen": 0,
            "DriverOpts": null
        }
    }
}
```

### Significado dos campos princípais

| Campo                                       | Descrição detalhada                                                                      |
| ------------------------------------------- | ---------------------------------------------------------------------------------------- |
| `MacAddress`                                | Endereço MAC virtual do container dentro da rede Docker.                                 |
| `NetworkID`                                 | Identificador único da rede Docker à qual o container está conectado.                    |
| `EndpointID`                                | Identificador do endpoint criado para o container na rede específica.                    |
| `Gateway`                                   | Endereço IP do gateway da rede, geralmente o IP da interface docker0 para a rede bridge. |
| `IPAddress`                                 | IP interno do container dentro daquela rede.                                             |
| `IPPrefixLen`                               | Máscara de sub-rede associada ao IP do container.                                        |
| `IPv6Gateway`                               | Gateway para a rede IPv6, se configurada.                                                |
| `GlobalIPv6Address` e `GlobalIPv6PrefixLen` | Endereço e máscara IPv6 globais, se atribuídos.                                          |

## Inspeção de redes Docker

Comando básico:

```bash
docker network inspect nome_rede
```

Retorna um JSON detalhando a configuração da rede.

Exemplo de saída resumida para rede bridge:

```json
[
    {
        "Name": "bridge",
        "Id": "9823a64207d9...",
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
        "ConfigFrom": { "Network": "" },
        "ConfigOnly": false,
        "Containers": {
            "container_id": {
                "Name": "nome_container",
                "EndpointID": "endpoint_id",
                "MacAddress": "02:42:ac:11:00:02",
                "IPv4Address": "172.17.0.2/16",
                "IPv6Address": ""
            }
        },
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

### Campos importantes para compreensão da rede

| Campo                       | Explicação detalhada                                                 |
| --------------------------- | -------------------------------------------------------------------- |
| `Name`                      | Nome da rede Docker.                                                 |
| `Id`                        | ID único da rede.                                                    |
| `Scope`                     | Alcance da rede: geralmente `local` para redes locais do host.       |
| `Driver`                    | Tipo de driver usado (ex: bridge, overlay, host).                    |
| `EnableIPv4` e `EnableIPv6` | Se a rede suporta IPv4 e IPv6, respectivamente.                      |
| `IPAM`                      | Configurações de gerenciamento de IP, incluindo sub-rede e gateway.  |
| `Internal`                  | Se a rede é interna (sem acesso externo).                            |
| `Attachable`                | Se containers podem se conectar manualmente a essa rede.             |
| `Ingress`                   | Se é uma rede de ingresso para Docker Swarm.                         |
| `Containers`                | Lista de containers conectados e seus detalhes de IP e MAC.          |
| `Options`                   | Parâmetros específicos do driver, como MTU, masquerading e bindings. |

## Diagnóstico prático

### Validando conectividade

Para verificar se containers estão na mesma rede e podem se comunicar, liste os containers conectados na rede:

```bash
docker network inspect bridge
```

Veja o campo Containers e anote os IPs.
Entre em um container:

```bash
docker exec -it nome_container sh
```

Faça ping no IP ou no nome de outro container (se rede personalizada):

```bash
ping 172.17.0.3
ping nome_container_alvo
```

### Diagnóstico de problemas comuns

| Problema                      | Diagnóstico                                                      | Correção / Ação recomendada                                   |
| ----------------------------- | ---------------------------------------------------------------- | ------------------------------------------------------------- |
| Container não responde ping   | Verificar se o container está na mesma rede.                     | Conectar container na mesma rede com `docker network connect` |
| Comunicação falhando via nome | Rede padrão bridge não resolve nomes; redes personalizadas sim.  | Criar rede personalizada e conectar containers nela           |
| IP mudou após reinício        | Container efêmero: IP atribuído dinamicamente no start.          | Usar nomes de container em vez de IPs fixos                   |
| Conflito de portas na host    | Container usando rede host pode ter conflito com portas do host. | Usar mapeamento de portas em redes bridge ou personalizadas   |

## Exemplo detalhado — Analisando a rede bridge e container

Suponha que temos um container chamado app_web. Executamos:

```bash
docker inspect app_web
```

Procuramos a seção NetworkSettings.Networks.bridge:

```json
"bridge": {
    "IPAMConfig": null,
    "Links": null,
    "Aliases": null,
    "MacAddress": "02:42:ac:11:00:02",
    "NetworkID": "9823a64207d9...",
    "EndpointID": "endpoint_id",
    "Gateway": "172.17.0.1",
    "IPAddress": "172.17.0.2",
    "IPPrefixLen": 16,
    "IPv6Gateway": "",
    "GlobalIPv6Address": "",
    "GlobalIPv6PrefixLen": 0,
    "DriverOpts": null
}
```

O container está na rede bridge.

Seu IP interno é 172.17.0.2 dentro da sub-rede 172.17.0.0/16.

A comunicação entre containers da mesma rede bridge é possível por esses IPs.

## Boas práticas para inspeção

Sempre use o comando docker network inspect para entender as redes ativas e configurações detalhadas.

**Para múltiplos containers que precisam se comunicar, prefira redes personalizadas:** elas fornecem resolução de nomes automática e isolamento.

Analise Options e parâmetros do driver para ajustar MTU, mascaramento e outras opções avançadas.

Use ferramentas externas (como tcpdump e wireshark) para análise profunda de tráfego dentro da rede docker0, caso necessário

## Resumo

O comando docker inspect é a ferramenta chave para diagnóstico.

As seções NetworkSettings e Containers em docker network inspect são os principais pontos para entender IPs, gateways, MACs e configurações.

Conhecer a estrutura do JSON facilita diagnósticos precisos.

Problemas comuns em redes Docker geralmente derivam do uso inadequado das redes padrão e do não aproveitamento das redes personalizadas.

Rede efêmera e IP dinâmico exigem o uso da resolução de nomes para comunicação robusta.