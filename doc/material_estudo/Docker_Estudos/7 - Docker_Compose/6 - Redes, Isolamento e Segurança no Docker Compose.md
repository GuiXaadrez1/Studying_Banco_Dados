# Introdução

O Docker Compose implementa uma camada de abstração sobre o driver de rede do Docker Engine, permitindo o isolamento, interconexão e roteamento interno entre serviços definidos no mesmo ambiente.

A modelagem adequada das redes é essencial para assegurar:

- Segurança (redução da superfície de ataque)

- Performance (redução de latência entre serviços)

- Escalabilidade (controle granular do tráfego interno e externo)

## Conceitos Fundamentais de Rede no Docker

### Driver bridge (padrão):

- Cria uma rede virtual isolada para containers no mesmo compose project.

- Containers se comunicam por DNS interno (nome do serviço).

### Driver host

- O container compartilha a pilha de rede do host.

- Elimina isolamento, útil para aplicações que precisam de alta performance de rede ou detecção automática de IP.

- Não recomendado para produção em ambientes multi-tenant.

## Driver overlay (Swarm mode)

Permite comunicação entre containers distribuídos em múltiplos hosts.

Usado para orquestração distribuída.

## Definição de Redes no Docker Compose

Exemplo:

```yaml
# definindo a versão do do docker compose (não é obrigado a colocar)
version: "3.9"

# Declarando globalmente as redes 
networks:
  # esse é o nome da nossa primeira rede personalizada
  backend:
    # esse é o driver que vamos usar
    driver: bridge
  # esse é o nome da nossa segunda rede personalizada
  frontend:
    # esse é o driver que ela vai usar
    driver: bridge

# Isso é a declaração global de redes no arquivo docker-compose.yml.
# Cada rede é uma camada de isolamento de comunicação entre containers.

# Definindo o meu serviço - conjunto de container (pode ser 1 ou +)
services:
  # definindo o nome do meu primeiro container
  api:
    # defininfo a imagem que ele vai usar
    image: my-api:latest
    # definindo a rede personalizada que ele vai está
    networks:
      - backend
  # definindo o nome do nosso segundo container
  web:
    # definindo a imagem que ele vai usar
    image: my-web:latest
    # definindo a rede personalizada que esse container vai está
    networks:
      - frontend
      - backend
```

## Explicação técnica:

**networks**: na raiz define redes personalizadas.

A associação do serviço a múltiplas redes permite que ele funcione como gateway interno.

A resolução de DNS é feita automaticamente pelo nome do serviço.

## Por que duas redes?

**backend** → é pensada para comunicação interna entre containers que processam lógica de negócio ou acessam dados (ex.: API ↔ Banco de Dados).

**frontend** → é pensada para comunicação de containers voltados à interface ou serviços externos (ex.: servidor web, proxy, CDN).

## Como funciona na prática?

Quando você sobe o docker-compose up, o Docker cria duas redes bridge separadas no host.

Containers só se comunicam se estiverem na mesma rede.

Se um container estiver em duas redes, ele atua como uma “ponte” entre elas.

api só vê quem está no backend.

web vê o frontend e o backend.

### 📌 Por que declarar as redes globalmente?

Isso permite que mais de um serviço use a mesma rede sem redefinir toda hora.

No Docker Compose, tudo que aparece fora de services: é recurso compartilhado (volumes, redes, configs, secrets).

## Isolamento de Serviços

Containers não conectados à mesma rede não conseguem se comunicar.

Estratégia recomendada para segmentação de segurança:

Criar redes dedicadas para cada domínio funcional.

Permitir acesso cruzado apenas a serviços intermediários (ex.: API Gateway).

## Resolução de Nome Interna

DNS interno do Docker resolve pelo nome do serviço definido no Compose.

### Exemplo:

Se um serviço db estiver na rede backend, a aplicação no serviço api pode se conectar usando db:5432.

## Mapeamento de Portas

Configuração no Compose:

```yaml
ports:
  - "8080:80"
``` 

**Primeiro valor:** porta exposta no host.

**Segundo valor:** porta interna do container.

Expor portas apenas quando necessário para reduzir riscos de ataque.

## Segurança de Redes

Boas práticas:

- Redes privadas para comunicação interna (sem ports expostas).

- Uso de firewalls de container (via iptables ou ufw) para regras adicionais.

- TLS interno para criptografar tráfego mesmo dentro da rede Docker.

- Evitar network_mode: host exceto em casos controlados.

## Performance e Latência

O driver bridge é suficiente para a maioria dos cenários locais e de produção em host único.

Latência entre containers no mesmo host e rede bridge é tipicamente < 1ms.

Para workloads de alto volume de rede:

- Ajustar MTU da rede.

- Reduzir camadas de abstração.

- Usar host network (avaliando riscos).

## Diagnóstico de Redes

Listar redes existentes:

```bash
docker network ls
```

## Inspecionar rede específica:

```bash
docker network inspect backend
```

Testar comunicação entre containers:

```bash
docker exec -it <container> ping <serviço>
```

## 📌 Observação científica:

O modelo de rede do Docker Compose se assemelha a uma topologia overlay local, onde o namespace de rede é isolado por projeto, e o roteador interno atua como resolvedor de nomes e controlador de tráfego unicast entre serviços. Este modelo é determinístico em nível de configuração, mas o desempenho é influenciado por fatores como concorrência de I/O e carga do host.