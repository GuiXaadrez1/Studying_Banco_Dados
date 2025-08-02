# Introdução

Este documento visa otimizar o processo de  instalação do docker para quem é usuário do sistema operacional Windows, lembrando que o WSL já deve está instalado e configurado.

## Primeiro passo. Seguir os passos da documentação de instalação do Docker Engine

documentação1: https://docs.docker.com/engine/install/ubuntu/

### Comandos passo a passo da documentação acima: 

1 - Execute o seguinte comando para desinstalar todos os pacotes conflitantes:

```ubuntu
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
```

**observação:** pode informar que você não tem nenhum desses pacotes instalados.

```ubuntu
apt-get
```

2 - Instale usando o apt repositório. Antes de instalar o Docker Engine pela primeira vez em uma nova máquina host, você precisa configurar o Docker apt repositório. Depois, você pode instalar e atualizar Docker do repositório.

```ubuntu

    # Add Docker's official GPG key:
    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update

```

3 - Instale os pacotes Docker.

```ubuntu
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

4 - Verifique se a instalação foi bem-sucedida executando o hello-world imagem:

```ubuntu
sudo docker run hello-world
```

Este comando baixa uma imagem de teste e a executa em um contêiner. Quando o o contêiner é executado, ele imprime uma mensagem de confirmação e sai.

Agora você instalou e iniciou com sucesso o Docker Engine.

Vai aparecer algomo como:

```ubuntu

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/

```

### TRADUÇÃO

Olá do Docker!

Esta mensagem mostra que sua instalação parece estar funcionando corretamente.

Para gerar esta mensagem, o Docker executou os seguintes passos:

1️⃣ O cliente Docker entrou em contato com o daemon Docker.

2️⃣ O daemon Docker fez o download da imagem "hello-world" a partir do Docker Hub.
(amd64)

3️⃣ **O daemon Docker criou um novo container a partir dessa imagem, que executa o programa que gera a saída que você está lendo agora.**

4️⃣ O daemon Docker transmitiu essa saída para o cliente Docker, que a enviou para o seu terminal.

Para tentar algo mais avançado, você pode executar um container Ubuntu com:

```bash
$ docker run -it ubuntu bash
```
Compartilhe imagens, automatize fluxos de trabalho e muito mais com uma conta Docker 
gratuita:

https://hub.docker.com/

Para mais exemplos e ideias, visite:
https://docs.docker.com/get-started/

BASICAMENTE CRIAMOS O NOSSO PRIMEIRO CONTEINER (AMBIENTE ISOLADO) COM ESSE COMANDO

## Segundo passo. Seguir os passos na documentação de pós-instalação do Docker Engine

https://docs.docker.com/engine/install/linux-postinstall/

### Comandos passo a passo da documentação acima:

1 - Para criar o docker agrupe e adicione seu usuário:
```ubuntu
sudo groupadd docker
```

2 - Adicione seu usuário ao docker grupo.
```ubuntu
sudo usermod -aG docker $USER
```
3 - Faça logout e faça login novamente para que sua associação ao grupo seja reavaliada.

Se você estiver executando o Linux em uma máquina virtual, pode ser necessário reinicie a máquina virtual para que as alterações entrem em vigor.

Você também pode executar o seguinte comando para ativar as alterações nos grupos:

```ubuntu
newgrp docker
```

4 - Verifique se você pode correr docker comandos sem sudo.

```ubuntu
docker run hello-world
```

Este comando baixa uma imagem de teste e a executa em um contêiner. Quando o o contêiner é executado, ele imprime uma mensagem e sai.

Se você inicialmente executou comandos CLI do Docker usando sudo antes de adicionar seu usuário ao docker grupo, você pode ver o seguinte erro:

```bash
WARNING: Error loading config file: /home/user/.docker/config.json -
stat /home/user/.docker/config.json: permission denied
```

Este erro indica que as configurações de permissão para o ~/.docker/ diretório estão incorretos, devido a ter usado o sudo comando anterior.

Para corrigir esse problema, remova o ~/.docker/ diretório (é recriado automaticamente, mas quaisquer configurações personalizadas são perdidas) ou altere sua propriedade e permissões usando os seguintes comandos:

```ubuntu
sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
sudo chmod g+rwx "$HOME/.docker" -R
```
### Configure o Docker para iniciar na inicialização com o systemd

Muitas distribuições Linux modernas usam sistema para gerencie quais serviços começam quando o sistema é inicializado. No Debian e Ubuntu, o O serviço Docker começa na inicialização por padrão. Para iniciar automaticamente o Docker e containerd na inicialização para outras distribuições Linux usando systemd, execute o seguintes comandos:

```ubuntu
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
```

Para parar esse comportamento, use disable em vez disso.

```ubuntu
sudo systemctl disable docker.service
sudo systemctl disable containerd.service
```

Você pode usar arquivos de unidade systemd para configurar o serviço Docker na inicialização, por exemplo, para adicionar um proxy HTTP, defina um diretório ou partição diferente para o Arquivos de tempo de execução do Docker ou outras personalizações.