# Introdução
Este documento visa mostrar como funciona os comandos de manipulação básica (listar, excluir, criar) para imagens e container 

## Lista de comandos:

### Fazendo um pull, baixando um container que está salvo no docker hub para o nosso repositório local

```bash
docker pull nome_imagem_container_hub
```

### Vendo se o docker está ativo ou não

```bash
sudo service docker status 
```
Vai pedir para você colocar a senha de super usuário, ou usuário do Linux, lembre-se sempre da distribuidoras do Linux que você está usando

### Inicializando o Docker
```bash
sudo service docker start
```

### Parando um Docker
```bash
sudo service docker stop    
```

### Reiniciando o Docker 
```bash
sudo service docker restart    
```

### Listar Conteiners que estão em execução
```bash
# essa é a sintaxe antiga
docker ps

# ou

docker ps -a # lista todos os containers, parados ou ativos

# essa é a sintaxe nova deste comando 
docker container ls -a
```

Vai retonar algo como: 

    CONTAINER ID   IMAGE         COMMAND    CREATED             STATUS                         PORTS     NAMES
    0222bcee65a3   hello-world   "/hello"   39 minutes ago      Exited (0) 39 minutes ago                magical_villani
    b65b6e6c90c2   hello-world   "/hello"   About an hour ago   Exited (0) About an hour ago             cool_stonebraker


### Verifica, lista imagens que estão no nosos repositório local
```bash
docker images
```

Vai retornar algo como:

    REPOSITORY    TAG       IMAGE ID       CREATED        SIZE
    hello-world   latest    74cc54e27dc4   6 months ago   10.1kB

## Removendo o nosso container, que estão no nosso repositório local

Para remover um conteiner, podemos fazer pelo seu ID ou pelo seu nome, também podemos remover pelos os 4 primeiros caracteres do ID do container

```bash
# Excluindo container pelo ID completo
docker rm 0222bcee65a3

# Excluindo container pelo nome dele
docker rm  magical_villani

# Excluindo container pelos quatros primeiros caracteres do ID 
docker rm 0222
```

### Removendo Imagem que estão no nosso repositório local
São semelhantes com os comandos de remoção do container, neste caso, colocamos o nome da imagem e o nome da tag também, só que ao invés de rm é rmi

```bash
# excluindo Imagem: docker rmi nome_imagem:vtag_imagem
docker rmi hello-world:latest
```

### Criando uma Imagem localmente
No Docker, quem cria uma imagem é o docker build, usando um Dockerfile.
A imagem é o modelo imutável — o container é a instância dela rodando.

Exemplo de DockerFile:

```DockerFile
# Dockerfile
FROM ubuntu:latest            # Imagem base (Ubuntu)
RUN apt-get update && apt-get install -y curl
CMD ["bash"]                  # Comando padrão quando o container iniciars
```

Supondo que você tenha salvo esse Dockerfile em uma pasta, rode:

```bash
docker build -t minha-imagem:1.0 .
```

docker build → comando para construir.

-t → define tag (nome:versão).

. → contexto de build (pasta onde está o Dockerfile).

Pronto! Você criou uma imagem chamada minha-imagem:1.0 que:

    Usa o Ubuntu.

    Instala curl.

    Sobe rodando um shell bash.

### Criando um container para o nosso repositório local

Quando você executa docker run, o Docker:

1️⃣ Puxa a imagem (ou usa local).
2️⃣ Cria uma camada mutável (camada de escrita).
3️⃣ Cria um container — que é a instância viva da imagem.
4️⃣ Executa o ENTRYPOINT / CMD da imagem.

Exemplo:
```bash
docker run -it minha-imagem:1.0 --name
```

-it → terminal interativo.

minha-imagem:1.0 → sua imagem.

--name (opcional) → define o nome do container

Como o CMD é bash, você entra num shell interativo dentro do container.

### Fluxo completo - ciclo de vida:

| Etapa                                 | Comando                              |
| ------------------------------------- | ------------------------------------ |
| Criar imagem                          | `docker build -t minha-imagem:1.0 .` |
| Rodar container                       | `docker run -it minha-imagem:1.0`    |
| Ver containers ativos                 | `docker ps`                          |
| Ver containers todos (ativos/parados) | `docker ps -a`                       |
| Parar container                       | `docker stop <container_id>`         |
| Remover container                     | `docker rm <container_id>`           |
| Remover imagem                        | `docker rmi minha-imagem:1.0`        |

**OBSERVAÇÃO:**

Imagem:

    É imutável — um snapshot com tudo o que o container precisa: sistema base, dependências, binários, entrypoint.

    Ex.: hello-world:latest — sempre igual até você atualizar/puxar outra.

Container:

    É instância em execução (ou parada) criada a partir da imagem.
    Contém camadas mutáveis: logs, alterações no sistema de arquivos, configurações runtime (volumes, network, ports).

Logo: Para remover uma imagem, você precisa remover aquele conteiner que depende daquela imagem primeiro. Mas cuidado: se houver outros containers (mesmo parados) usando essa imagem, o docker rmi vai falhar até você remover todos os containers dependentes. A legando o seguinte error:

    conflict: unable to remove repository reference "hello-world:latest" (must force) - container b65b6e6c90c2 is using its referenced image 74cc54e27dc4


**LEMBRE-SE:** Container em docker são efêmeros, isto é temporários, ele deixam de realizar as suas atividades assim que completa, finaliza elas e voltam a ficar desativados sem aguarda outras instrulções, para evitar isso, ativamos o modo iterativo do docker com o seguinte comando:

```bash
# Cria um container para aquela imagem que queromos executar
docker run -i -t nome_imagem

# -i → --interactive
# Mantém o STDIN aberto mesmo se não estiver conectado.
# Serve para enviar comandos interativos dentro do container.

# -t → --tty
# Aloca um terminal pseudo-TTY.
# Faz com que a saída dentro do container seja formatada como se fosse um terminal real.
# Garante que você tenha prompt interativo (ex.: bash, sh, REPL Python, etc).

# ✅ Combinação -it
# -i -t → -it é o padrão para rodar containers em modo interativo, como se fosse um SSH interno.

# Sem isso, você não consegue digitar comandos dentro do container interativamente.

# Para sair do container você usar o atalho: ctrl + d ou escreve: exit
exit

# isso vai fazer você finalizar as atividades do container
```

### Inspecionar um elemento, ver os detalhes de um elemento

Aqui podemos fazer a inspeção de uma imagem para o container e ver suas camadas

```bash
docker inspect nome_imagem_container_local
```

### Removendo todos os containers de uma vez só

```bash
docker container prune
```
### Removendo forçadamente um container 

```bash
docker rm -f id_container
```

### removendo variasa imagens de uma vez só
```bash
docker rmi $(docker images -q)
```

### renomeando o nome de um container

```bash
docker rename nome_antigo nome_novo
```

### Puxando o histórioco de camadas da imagem

```bash
docker history nome_container or id_container
```

### Listando todos os tipos de redes que os container docker trabalha
```bash
docker network ls
```
