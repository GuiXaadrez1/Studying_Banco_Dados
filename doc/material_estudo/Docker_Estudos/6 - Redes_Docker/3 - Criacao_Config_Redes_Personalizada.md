# Introdução

Para ambientes complexos e aplicações multi-container, o uso das redes padrão do Docker (bridge, host, none) muitas vezes não é suficiente.

Para garantir:

- Comunicação facilitada entre containers

- Isolamento específico de redes

- Resolução de nomes via DNS interno do Docker

- Controle sobre o range de IPs usados

- É necessário criar redes personalizadas.

## Por que criar redes personalizadas?

- Resolução de nomes: Em redes personalizadas, containers podem se comunicar usando seus nomes — o Docker automaticamente cria um DNS interno para essa finalidade.

- Isolamento de containers: Você pode agrupar containers que precisam se comunicar entre si, isolando-os de outros containers.

- Controle do subnet e gateway: Você pode especificar faixa de IP (subnet) e gateway para a rede, evitando conflitos.

- Configurações avançadas: Permite definir opções específicas, como políticas de roteamento e exposição.

## Criando uma rede personalizada com driver bridge

Comando básico:

```bash
docker network create --driver bridge nome_da_rede
```
--driver bridge indica que a rede usará o driver bridge.

nome_da_rede é o nome que você escolher para essa rede.

### Verificando a rede criada

```bash
docker network ls
```

Saída deverá conter:

```bash
NETWORK ID     NAME               DRIVER    SCOPE
<id>          minha_rede_bridge  bridge    local
```

### Inspecionando a rede personalizada

```bash
    docker network inspect minha_rede_bridge
```
Exemplo de saída simplificada:

```json
[
    {
        "Name": "minha_rede_bridge",
        "Id": "abcd1234efgh5678",
        "Driver": "bridge",
        "IPAM": {
            "Config": [
                {
                    "Subnet": "172.18.0.0/16",
                    "Gateway": "172.18.0.1"
                }
            ]
        },
        "Containers": {}
    }
]
```

## Criando redes com configurações avançadas

É possível definir faixa de IP (subnet), gateway, e outros parâmetros.

Sintaxe:

```bash
docker network create \
  --driver bridge \
  --subnet 192.168.100.0/24 \
  --gateway 192.168.100.1 \
  nome_da_rede_customizada
```

Exemplo:

```bash
docker network create \
  --driver bridge \
  --subnet 192.168.100.0/24 \
  --gateway 192.168.100.1 \
  rede_customizada
```
Isso cria uma rede com:

- Faixa de IPs de 192.168.100.0 a 192.168.100.255

Gateway na porta .1

## Associando containers a redes personalizadas
Ao iniciar um container, use a flag --network para conectar o container à rede desejada:

```bash
docker run -dit --name meu_container --network rede_customizada imagem
```

## Conectando e desconectando containers a redes

### Conectar um container existente a uma rede

```bash
docker network connect nome_da_rede nome_container
```

### Desconectar um container de uma rede
```bash
docker network disconnect nome_da_rede nome_container
```
## Comunicação entre containers usando nomes

**Quando containers estão na mesma rede personalizada, o Docker resolve o nome do container como hostname automaticamente.**

Exemplo:

- Container app pode acessar db usando ping db ou conexão via hostname db.

- Isso elimina a necessidade de usar IPs fixos, que podem mudar.

Exemplo prático completo

### Passo 1: Criar rede (SEMPRE)

```bash
docker network create --driver bridge minha_rede
```

### Passo 2: Criar container db na rede

```bash
docker run -dit --name db --network minha_rede mongo
```

### Passo 3: Criar container app na rede

```bash
docker run -dit --name app --network minha_rede alpine sh
```

### Passo 4: Testar comunicação por nome

```bash
docker exec -it app ping db
```

Se o ping funcionar, a rede e a resolução de nomes estão configuradas corretamente.

## Remoção de redes

Para remover uma rede, certifique-se que não há containers conectados, então use:

```bash
docker network rm nome_da_rede
```

### Observações importantes
Redes padrão (bridge, host, none) não podem ser removidas.

Use redes personalizadas para ambientes de produção e desenvolvimento complexo.

O Docker gerencia automaticamente o IPAM para evitar conflitos.

É possível combinar múltiplas redes para containers, criando arquiteturas complexas.

## Resumo

Redes personalizadas fornecem isolamento, resolução de nomes e controle total sobre endereçamento IP.

Criar redes com docker network create permite definir parâmetros avançados como subnet e gateway.

Containers conectados a redes personalizadas comunicam-se por nome, facilitando arquitetura de microserviços.

É possível conectar/desconectar containers a redes existentes, ampliando a flexibilidade.

O uso correto de redes personalizadas é uma prática recomendada para aplicações distribuídas em Docker.
