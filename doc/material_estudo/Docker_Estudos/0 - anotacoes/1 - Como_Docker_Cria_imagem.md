# Introdução

Esta documentação é um resumo de como o docker cria imagem, pode ser uma imagem criada no repositório local ou podemos usar uma imagem de um repositório remoto do Docker Hub, caso essa imagem do repositório local não exista, o exemplo disso foi o nosso primeiro container, que é um container padrão do Docker, pois como não tinhamos uma imagem.

## O Pull do Docker quando não temos a imagem no nosso repositório local

Vamos pegar a explicação do container hello-world do nosso primeiro repositório:

1️⃣ O cliente Docker entrou em contato com o daemon Docker.

2️⃣ O daemon Docker fez o download da imagem "hello-world" a partir do Docker Hub.
(amd64)

3️⃣ **O daemon Docker criou um novo container a partir dessa imagem, que executa o programa que gera a saída que você está lendo agora.**

4️⃣ O daemon Docker transmitiu essa saída para o cliente Docker, que a enviou para o seu terminal.

## Craindo locamente este repositório

Para criamos um container no repositório local, primeiro devemos criar a imagem deste container através de um arquivo que chamaos de DockerFile, ou seja, o Dockerfile é o blueprint da imagem.

### 📌 O que é o Dockerfile?

É um arquivo de texto com instruções declarativas, que define passo a passo como construir uma imagem de container.

Ele não é a imagem em si — é o roteiro que o Docker segue para gerar a imagem imutável.

Cada instrução (FROM, RUN, COPY, CMD...) cria uma camada na imagem final.

### ⚙️ Fluxo resumido

| Etapa                | O que faz                                                                                            |
| -------------------- | ---------------------------------------------------------------------------------------------------- |
| 📄 **1. Dockerfile** | Você escreve instruções declarando **o que precisa estar na imagem**.                                |
| 🏗️ **2. Build**     | Você roda `docker build` → o Docker lê o `Dockerfile` e gera a **imagem**.                           |
| 🚢 **3. Run**        | Você executa `docker run` → o Docker cria um **container**, que é a **instância viva** dessa imagem. |


📂 Exemplo real de Dockerfile

```Dockerfile
# Usa imagem base oficial do Node.js
FROM node:20

# Define diretório de trabalho dentro do container
WORKDIR /app

# Copia o código fonte para dentro da imagem
COPY . .

# Instala dependências
RUN npm install

# Comando padrão quando o container iniciar
CMD ["node", "index.js"]
```

### ⚙️ Como gerar a imagem

```bash

docker build -t meu-node-app:1.0 .

-t → nome e tag da imagem.

. → contexto de build (onde está o Dockerfile e o código).
```

###⚡ Resultado
O Dockerfile vira uma imagem Docker (meu-node-app:1.0).

Essa imagem é imutável.

Sempre que rodar:

```bash
docker run meu-node-app:1.0
```
você cria um container novo, instanciado dessa imagem, com o ambiente exatamente igual.

### 📌 Resumo — Containers

| Elemento       | Descrição                               |
| -------------- | --------------------------------------- |
| **Dockerfile** | Roteiro declarativo para gerar a imagem |
| **Imagem**     | Resultado do build, snapshot imutável   |
| **Container**  | Instância viva da imagem, executa o app |

### 🧩 Ponto chave

Dockerfile = Receita

docker build = Cozinha

Imagem = Prato pronto

docker run = Servir o prato