# Introdução

O Docker Compose é um orquestrador de containers em nível de aplicação que utiliza um arquivo declarativo (docker-compose.yml) para definir, configurar e interconectar múltiplos serviços de software.

O entendimento do ciclo de vida operacional de um projeto gerenciado via Compose é fundamental para otimizar a execução, reduzir latência de inicialização e manter consistência entre ambientes de desenvolvimento e produção.

## Fases do Ciclo de Vida

O ciclo de vida operacional pode ser dividido nas seguintes etapas formais:

### Preparação
Definição do arquivo de configuração (docker-compose.yml), contendo:

- Serviços

- Redes

- Volumes

- Dependências

- Criação de arquivos Dockerfile para serviços que necessitam de imagens customizadas.

- Configuração opcional de variáveis de ambiente via arquivo .env.

## Build
Execução do processo de image building:

- Leitura da diretiva build.context.

- Execução sequencial de instruções do Dockerfile.

- Aplicação de layer caching para evitar recompilações desnecessárias.

Comando:

```bash
docker compose build
```

## Inicialização (Up)

- Criação de redes definidas (por padrão bridge).

- Criação e execução de containers a partir das imagens.

- Aplicação de mapeamento de portas (ports) e montagem de volumes (volumes).

Comando:

```bash
docker compose up -d
# lembrando que o -d faz com que o docker execute os container em segundo plano 
```

## Execução e Monitoramento

### Monitoramento em tempo real via:

```bash
docker compose logs -f
```

## Inspeção de redes e containers com:

```bash
docker network inspect <network>
docker ps
```

## Parada
Suspensão de containers mantendo seus volumes e redes.

```bash
docker compose stop
```

### Remoção

### Remoção de containers e redes associadas:

```bash
docker compose down
```

### Remoção de volumes persistentes:

```bash
docker compose down -v
```

## Resolução de Dependências

depends_on define ordem de inicialização, mas não garante readiness do serviço.
Para garantir disponibilidade lógica, recomenda-se a utilização de healthcheck:

Esse é um recurso fundamental que define condições de existência do contêiner. Uma ferramenta deve validar se o contêiner está ok e o Docker fará uso dessa ferramenta (ou linha de comando). Além disso há parâmetros como o intervalo entre as verificações, retentativas em caso de falha, a partir de quando começa e qual é o timeout

```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost:8080"]
  interval: 10s
  retries: 5
```

### Observações:

O Compose atua como um controlador determinístico, mas o estado final depende de fatores não determinísticos como:

- Tempo de inicialização do serviço

- Latência de rede

- Disponibilidade de imagens externas

Para ambientes críticos, recomenda-se imagens pré-buildadas e healthchecks rigorosos.