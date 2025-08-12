# Introdução

Este arquivo visa deixar uma tabela explicando todos os componentes da estrutura de um arquivo.yaml do docker compose

## Componentes da Estrutura do docker-compose.yml

| Componente             | Descrição                                                               | Uso / Valores Possíveis                                                     | Exemplo                                                            |
| ---------------------- | ----------------------------------------------------------------------- | --------------------------------------------------------------------------- | ------------------------------------------------------------------ |
| `version`              | Define a versão da sintaxe do Docker Compose.                           | `'3'`, `'3.9'` (mais usada atualmente)                                      | `version: '3.9'`                                                   |
| `services`             | Bloco principal que agrupa os containers/serviços a serem orquestrados. | Lista de serviços, cada um com suas configurações                           | `services: { web: {...} }`                                         |
| `image`                | Define a imagem Docker a ser usada.                                     | Nome da imagem (`nginx`, `postgres:14`, etc.)                               | `image: nginx:latest`                                              |
| `build`                | Configuração para construir a imagem localmente.                        | Pode ter `context` (diretório base) e `dockerfile` (arquivo personalizado). | `build: { context: ./app, dockerfile: app.dockerfile }`            |
| `ports`                | Mapeamento de portas entre host e container.                            | `"HOST:CONTAINER"` ou lista                                                 | `ports: ["8080:80"]`                                               |
| `environment`          | Variáveis de ambiente dentro do container.                              | Lista (`- VAR=valor`) ou mapa (`VAR: valor`)                                | `environment: [ NODE_ENV=prod ]`                                   |
| `volumes`              | Monta volumes ou bind mounts para persistência/dados.                   | `"host_path:container_path"` ou volume nomeado                              | `volumes: ["./data:/app/data"]`                                    |
| `networks`             | Define redes personalizadas e a quais redes cada serviço pertence.      | Nome de redes e driver (`bridge`, `overlay`, etc.)                          | `networks: { minha_rede: { driver: bridge } }`                     |
| `depends_on`           | Define dependência de inicialização entre serviços.                     | Lista de nomes de outros serviços                                           | `depends_on: ["db"]`                                               |
| `restart`              | Política de reinício automático do container.                           | `no`, `always`, `on-failure`, `unless-stopped`                              | `restart: always`                                                  |
| `command`              | Sobrescreve o comando padrão da imagem.                                 | String ou lista                                                             | `command: ["npm", "start"]`                                        |
| `healthcheck`          | Configura teste de saúde para o container.                              | `test`, `interval`, `timeout`, `retries`                                    | `healthcheck: { test: ["CMD", "curl", "-f", "http://localhost"] }` |
| `extra_hosts`          | Adiciona entradas no `/etc/hosts` do container.                         | `"host:IP"`                                                                 | `extra_hosts: ["minhaapi:192.168.1.10"]`                           |
| `labels`               | Adiciona metadados (chave-valor) ao container.                          | Lista ou mapa                                                               | `labels: { com.example.description: "Meu app" }`                   |
| `tmpfs`                | Monta sistema de arquivos temporário na memória.                        | Caminho dentro do container                                                 | `tmpfs: /run`                                                      |
| `cap_add` / `cap_drop` | Adiciona ou remove capacidades do kernel para o container (segurança).  | Lista de capacidades (`NET_ADMIN`, etc.)                                    | `cap_add: ["NET_ADMIN"]`                                           |
| `ulimits`              | Define limites de recursos do sistema para o container.                 | `nofile`, `nproc`, etc.                                                     | `ulimits: { nproc: 65535, nofile: { soft: 20000, hard: 40000 } }`  |
