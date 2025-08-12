# Introdução

Por padrão, containers Docker são efêmeros: todos os dados gravados no sistema de arquivos interno são perdidos quando o container é removido.

Para aplicações que necessitam de retenção de dados — como bancos de dados, sistemas de cache persistente, e aplicações que armazenam arquivos de usuários — o Docker Compose fornece mecanismos de persistência via volumes e bind mounts.

## A escolha correta entre esses mecanismos impacta diretamente:

- Durabilidade

- Portabilidade

- Desempenho

- Manutenção

## Tipos de Persistência

### Volumes Gerenciados pelo Docker

Criados e gerenciados pelo Docker Engine.

Armazenados geralmente em /var/lib/docker/volumes.

Não dependem da estrutura de diretórios do host.

Excelente para portabilidade entre ambientes.

Declarados no Compose com:

```yaml
volumes:
  dados_db:
```

## Bind Mounts

Mapeiam um diretório específico do host para dentro do container.

Úteis para desenvolvimento (hot reload) e para compartilhar arquivos específicos.

Dependem da estrutura do host, logo menos portáveis.

Declarados no Compose com caminho absoluto:

```yaml
volumes:
  - /path/host/data:/var/lib/mysql
```

## Definição de Volumes no Docker Compose

Exemplo prático:

```yaml
version: "3.9"

# Declarando globalmente os nossos volumes
volumes:
  # definindo o nome do nosso volume 
  dados_db:
    # o driver do nosso volume
    driver: local

# Definindo o meu serviço - conjunto de container (pode ser 1 ou +)
services:
  # definindo o nome do meu container
  db:
    # definindo a imagem que ele vai usasr
    image: mysql:8.0
    
    # definindo quando ele vai reiniciar
    restart: always
    
    # declarando variáveis de ambiente
    environment:
      MYSQL_ROOT_PASSWORD: exemplo
    
    # definindo em qual diretório o meu volume vai estar
    volumes:
      - dados_db:/var/lib/mysql

# A parte de cima (volumes: global) → declaração do volume (o “cadastro” dele no Compose).

# A parte de baixo (volumes: dentro de services) → montagem do volume dentro do container.
```

## Análise técnica:

dados_db é um volume nomeado persistente, criado automaticamente.

O volume sobrevive a docker-compose down (a menos que seja usado --volumes).

O MySQL escreve dados em /var/lib/mysql, que no host mapeia para /var/lib/docker/volumes/<hash>/_data.

##  Analogia:

Pense na declaração global como “registrar um HD no servidor” e na montagem dentro do serviço como “plugar o HD na porta certa do container”.

## Por que parece que são dois volumes?

Na verdade, é o mesmo volume sendo mencionado em dois lugares:

- Global → para criar e configurar (ex.: driver, labels, opções).

- Serviço → para especificar onde ele vai ser montado no container.

O nome dados_db é o mesmo nos dois casos, então é o mesmo volume físico.

##  Como saber se é temporário, persistente ou bind mount
O comportamento depende de como você define o volume no Compose:

| Tipo               | Declaração global? | Caminho host especificado?                     | Persistência                                     |
| ------------------ | ------------------ | ---------------------------------------------- | ------------------------------------------------ |
| **Volume nomeado** | Sim                | Não                                            | Persiste até ser removido com `docker volume rm` |
| **Bind mount**     | Não precisa        | Sim (`/caminho/no/host:/caminho/no/container`) | Persiste no host (controlado por você)           |
| **Volume anônimo** | Não                | Não                                            | Some quando o container é removido               |

## Exemplos:

### Volume nomeado (persistente)

```yaml
volumes:
  meu_volume:
services:
  app:
    volumes:
      - meu_volume:/app/data
```

➜ Criado pelo Docker, persiste mesmo que o container seja apagado.

## sBind mount (persistente no host)

```yaml
services:
  app:
    volumes:
      - ./dados:/app/data
```

➜ Usa a pasta ./dados do host. Você gerencia o conteúdo.

### Volume anônimo (temporário)

```yaml
services:
  app:
    volumes:
      - /app/data
```

➜ Criado sem nome, removido quando o container é apagado.

### Por que essa estrutura é importante

Rede global → garante isolamento e controle de comunicação.

Volume global → garante persistência e compartilhamento de dados entre múltiplos containers.

Separar declaração e uso → te dá controle centralizado sobre a infraestrutura no docker-compose.yml.

## Ciclo de Vida dos Volumes

Criado quando um serviço que o utiliza é iniciado pela primeira vez.

Persiste após remoção do container.

Excluído apenas manualmente (docker volume rm) ou com docker-compose down --volumes.

## Estratégias de Backup e Restauração

Backup de Volume:

```bash
docker run --rm -v dados_db:/volume -v $(pwd):/backup alpine tar czf /backup/dados_db.tar.gz -C /volume .
```

### Restauração de Volume:

```bash
docker run --rm -v dados_db:/volume -v $(pwd):/backup alpine tar xzf /backup/dados_db.tar.gz -C /volume
```

## Performance

Volumes gerenciados pelo Docker são mais rápidos que bind mounts na maioria dos casos, pois otimizam acesso I/O.

Bind mounts podem sofrer overhead dependendo do filesystem do host.

Para cargas de alto desempenho (ex.: PostgreSQL com alto throughput), preferir volumes nativos.

## Boas Práticas

Usar volumes nomeados para dados de produção (melhor gerenciamento e isolamento).

Evitar bind mounts em produção, exceto para arquivos de configuração específicos.

Documentar mapeamentos de diretórios para evitar dependências ocultas.

Criar scripts de backup automatizado integrados ao pipeline de deploy.

## Considerações

Do ponto de vista de engenharia de software, volumes no Docker podem ser modelados como um sistema de armazenamento persistente desacoplado do ciclo de vida do container.
Isso permite aplicar princípios de stateful services sobre uma plataforma originalmente orientada a stateless computing, mitigando a volatilidade da infraestrutura sem comprometer a reprodutibilidade dos ambientes.