## Introdução à Persistência de Dados no Docker

Containers Docker são efêmeros: quando parados ou removidos, seus dados internos são perdidos. Para preservar dados críticos (como bancos de dados), usamos volumes e bind mounts.

Volume: armazenamento gerenciado pelo Docker, isolado do sistema de arquivos do host.

Bind mount: conecta um diretório do host diretamente ao container.

Este capítulo detalha a criação, configuração e uso avançado de volumes, principalmente via Docker Compose.

## Tipos de armazenamento para dados

| Tipo          | Definição                          | Uso Principal              | Vantagens                   | Desvantagens                    |
| ------------- | ---------------------------------- | -------------------------- | --------------------------- | ------------------------------- |
| Volume Docker | Área gerenciada pelo Docker        | Persistência em containers | Fácil backup, portabilidade | Isolado do host                 |
| Bind Mount    | Diretório do host montado no cont. | Desenvolvimento local      | Facilita edição e debug     | Pode ter problemas de permissão |

## Criando volumes Docker via linha de comando

```bash
docker volume create nome_volume
```

### Listar volumes:

```bash
docker volume ls
```

### Remover volume:

```bash
docker volume rm nome_volume
```

## Uso de volumes em docker-compose.yml

Exemplo avançado para MongoDB:

```yaml
services:
  mongodb:
    image: mongo:6.0
    volumes:
      - mongo_data:/data/db

volumes:
  mongo_data:
    driver: local
```

## Bind mounts em docker-compose.yml

Se quiser mapear diretório local para dentro do container:

```yaml
services:
  app:
    volumes:
      - ./app_data:/app/data
```

Isso conecta a pasta local app_data na pasta /app/data dentro do container.

## Configurações avançadas de volumes

### Definindo opções de driver

```yaml
volumes:
  mongo_data:
    driver: local
    driver_opts:
      type: 'none'
      device: '/path/no/host/para/dados'
      o: 'bind'
```

Esse exemplo cria um volume com bind mount manual.

## Backup e restauração de volumes

Backup:

```bash
docker run --rm -v mongo_data:/data/db -v $(pwd):/backup alpine tar czvf /backup/backup_mongo.tar.gz -C /data/db .
```

## Restauração:

```bash
docker run --rm -v mongo_data:/data/db -v $(pwd):/backup alpine sh -c "cd /data/db && tar xzvf /backup/backup_mongo.tar.gz --strip 1"
```

## Permissões e usuários

Containers podem rodar com usuários diferentes. Problemas de permissão no volume/bind mount são comuns.

Utilize user no Dockerfile para definir usuário.

Configure permissões no host para o diretório de bind mount.

Use chown para ajustar propriedade.

## Volumes nomeados x bind mounts: qual escolher?

| Critério         | Volume Nomeado | Bind Mount                      |
| ---------------- | -------------- | ------------------------------- |
| Portabilidade    | Alta           | Baixa (depende do host)         |
| Desempenho       | Leve variação  | Geralmente melhor no host       |
| Facilidade debug | Média          | Alta (acesso direto a arquivos) |
| Segurança        | Isolado        | Possível exposição do host      |

## Resumo

Volumes Docker garantem persistência e portabilidade de dados.

Bind mounts são úteis para desenvolvimento local e debugging.

Configurações avançadas permitem personalizar volumes para necessidades específicas.

Backup e restauração de volumes devem ser parte do plano de manutenção.

Atenção a permissões para evitar erros no acesso a arquivos.