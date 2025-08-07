# Introdução

Este documento registra como criar imagens Docker utilizando o comando docker commit.

⚠️ Atenção: Cada container Docker é instanciado a partir de uma imagem base, e cria uma camada de leitura e escrita por cima dessa imagem, sem modificá-la diretamente. Quando usamos docker commit, uma nova imagem é gerada com base nas modificações feitas no container — similar a como uma view no banco de dados representa dados sem alterar a tabela original.

❌ Importante: docker commit não é a forma recomendada de construir imagens Docker. Trata-se de uma abordagem pouco prática, difícil de versionar e menos reprodutível. Prefira o uso de Dockerfiles sempre que possível. Geralmente as imagens feitas pelo commit são mais pesadas.

## 📂 Verificando as camadas de uma imagem
Você pode inspecionar as camadas (layers) de uma imagem com:

```bash
docker history nome_da_imagem
```

Isso é útil para entender o histórico de modificações ou analisar imagens criadas a partir de containers modificados.

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

## Considerações Finais

A criação de imagens via docker commit é pesada, implícita e não reprodutível.

Verifique o tamanho das camadas geradas com docker history — você pode se surpreender com o consumo de espaço!

Uma possível (mas não ideal) abordagem é realizar commits incrementais após cada modificação, para isolar mudanças e reduzir acoplamento entre camadas.

## Melhor abordagem

Sempre que possível, use Dockerfiles para construir imagens. Eles são:

- Mais claros

- Mais fáceis de versionar

- Reprodutíveis em qualquer ambiente