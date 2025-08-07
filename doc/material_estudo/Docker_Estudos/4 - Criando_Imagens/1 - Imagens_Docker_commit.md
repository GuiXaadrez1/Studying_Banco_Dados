# Introdução

Este documento visa deixar registrado como podemos fazer imagens com docker commit

**Observações:** Cada container tem camada read/only (apenas para leitura) sem modificar de fato a imagem real inicial, ou seja cada commit, cada novo container com imagens novas a partir de outras imagens, são novas imagens sem modificar a imagem originam, veja a imagem original de um container como uma view do banco de dados.

**Lembrando:** Essa não é a melhor opção de criar uma imagem para um container docker, porque é muito custoso e não prático

## Obtendo todas as camadas de uma imagem

```bash
# use o comando 
docker history nome_imagem
```

Usamos para quando queremos puxar informações da imagem da aplicação que está no container

## Vamos criar um imagem do ubuntu de forma mais potencializada

Essa imagem vai poder  ter o curl (opcionais: vim, iputils-ping, ifconfig) a partir da imagem do ubuntu base

### Práticando

```bash
# fazendo um pull, inicializando e executando uma imagem oficial docker do ubuntu
docker run -it ubuntu

# atualizando apt (gerenciador de pacotes)
apt update

# instalando todo mundo de uma vez
apt install -y curl vim iputils-ping net-tools

# após terminar instalações, vamos terminar a execução do container

docker stop -t 0 nome_container or id_container

# agora fazemos o commit do container contendo os novos recursos, isso 
# vai fazer com que uma nova imagem seja gerada

docker commit nome_container or id_container nome_nova_imagem

## Lembrando que o commit salva a imegem no repositório local

# O docker commit funciona tanto para um container parado ou em execução

```

## Observações 
usar essa forma de fazer imagens para container é completamente pesada e implícita, para obter informações mais detalhada, devemos usar o comando docker history, ao vermos a quantidade de megabytes vamos dar até um pulo akakaka.

**Uma possível solução para isso é realizar um commit a cada alteração na nossa imagem de origem**

mesmo assim não é interessante usar essa forma para criar imagens, surgira que avalie bem a necessidade do seu problema para optar por essa solução.