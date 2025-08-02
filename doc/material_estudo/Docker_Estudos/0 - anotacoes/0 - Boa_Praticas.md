# Introdução 
Este documento visa deixar registrado boas práticas na manipulação do nosso docker

## Primeiro

Sempre veja se o seu Docker está prestando serviço, isto é, executando ou em estado de trabalho, inicializado. Lembre-se os containers do Docker são efêmeros, isto é: temporários, eles fazem o serviço e o trabalho deles e volta a ficar parados. Por isso é interessante usar o comando:

```bash
# visualizar se o docker está em estado de serviço
sudo service docker status

# ativar ele caso esteja desativado
sudo service docker start

# se necessário desativar ou reiniciar
sudo service docker stop

sudo service docker restart
```

Caso seja um container do Docker:

```bash
# lista todos os container locais
docker container  ls -a

# docker start nome do container para iniciar o container inativo
docker start nome_container

# caso seja necessário parar
docker stop nome_container
```
