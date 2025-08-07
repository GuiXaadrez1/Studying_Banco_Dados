# Introdução
Esta anotação visa deixar registrado alguns passos da resolução.

## Observações:

de cara já percebemos que vamos precisar de três DockerFile, mas neste caso, vamos colocar a extensão .dockerfile

lembre-se: Na hora de criar a imagem com o build, terá que específicar com a flag -f, exemplo a baixo:

```bash
docker build -f arq.dockerfile -t meu-app .

# tag -t atribui um nome e uma tag à imagem que está sendo construída.
```

## Primeiro Passo!
Lembrando que todas as imagens a serem utilizadas estão no DockerHub

A imagem do MongoDB é pesada, afim de otimizar essa migração, vamos pegar uma imagem do aloine que é uma distribuição leve do sistema operacional linux sistema operacional e instalar o MongoDB nele.

Vamos usar as imagens oficiais do MongoDB Express e do Node