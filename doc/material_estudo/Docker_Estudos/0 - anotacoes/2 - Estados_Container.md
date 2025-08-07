# Introdução 
Esta anotação visa deixar registrado como funciona o ciclo de vida de processo / Estados de um Processo (new,rendy,wait,block, suspended, waiting, running, terminated) de um container do docker.

**Lembre-se:** Docker é uma plataforma que gerencia container ao qual este contém um ambiente de aplicação isolado, isto é: application, libs, códigos, versões de aplicação e etc...

Como o docker é uma plataforma, um software, um programa com um conjunto de processos, e cada processo possui um estado no seu ciclo de vida, a mesma lógica se aplica aos containers deste docker.

### Imagem referente aos Estados de um processo
<img src = "https://afteracademy.com/blog/what-is-a-process-in-operating-system-and-what-are-the-different-states-of-a-process"/>

## Estados de um Container Docker

**Lembre-se:** Para criar um container novo e fazer com que ele seja executado use o comando:

```bash
docker run --nome nome_container -it imagem_container

# ou se quiser colocar para executar em segundo plano:

docker run --nome nome_container -dit imegem_container

# O -d diz: Rode  o container em segundo plano (background) e não me mantenha conectado ao terminal dele
```

### Container no estado de create (criado)
Basicamente é o estado que o container está criado e esperando para ser executado! Para descobrir, basta realiza o seguinte comando:

```bash
# para listar todos os containers 
docker ps -a

# Criar um container com o esado de CREATE
docker create -it nome_imagem_container
```

Vai retornar o seguinte STATUS:

CONTAINER ID   IMAGE     COMMAND       CREATED          STATUS    PORTS     NAMES
eb0e57141906   ubuntu    "/bin/bash"   22 seconds ago   Created             sweet_blackburn

### Container no estado de start (inicializado)

Para inicializar um container use o seguinte comando:

```bash
# inicializando um container, sempre fazer isso para container em estado de Exited
docker start nome_container or id_container

# ou usar...

docker start -ai nome_container or id_container

# start → inicia um container parado.

# -a → anexa a saída no terminal (stdout/stderr).

# -i → mantém a entrada interativa (stdin).
```

Vai retornar o seguinte STATUS: UP e tempo que foi inicializado

CONTAINER ID   IMAGE     COMMAND       CREATED         STATUS          PORTS     NAMES
eb0e57141906   ubuntu    "/bin/bash"   3 minutes ago   Up 11 seconds             sweet_blackburn

### reiniciar, restartar o nosso container
o restart, basicamente ele reinicia o container com todos os processos da nossa aplicação

```bash
docker restart nome_container or id_container
```

### Container no estado de deleted (deletado)

Forma padrão de deletar ou remover um container
```bash
docker rm nome_container or id_container
```

### Container no estado de running (executando ) para stopped

**Lembre-se:** O -d faz com que o docker rode a execução de um container em segundo plano, com isso não é possível ver mais nada a menos que execute logs.

**observações:**

Created -> Criado

UP -> Inicializado / Executando

Exited -> Terminado

```bash
# com o kill - finaliza imediatamente um container
docker run --name running-to-stopped-kill -dit ubuntu

# Matando, terminando forçadamente um container (nada mais que um processo)
docker kill nome_container or id_comtainer

# com o stop - finaliza um container com um temporizador de 10s
docker run --name running-to-stopped-stop -dit ubuntu

# finalizando o meu caontainer com pausa
docker stop nome_container or id_container

# O -d diz: Rode  o container em segundo plano (background) e não me mantenha conectado ao terminal dele

# colocar a flag -t no docker stop, estamos declarando o tempo em segundos que ele vai demorar para desligar
```

Cuidado ao usar esse tipo de comando, pois pode comprometer a integridade de todos os processos sendo executado na aplicação no container que acabou de ser morto (kill) ou termiando pausadamente (stop), o stop é um pouco mais seguro pois ele da um tempo para que a aplicação consiga manter a sua integridade antes de terminado

Vai retornar algo como:

guilherme@LAPTOP-5R0D7027:~$ docker ps -a
CONTAINER ID   IMAGE     COMMAND       CREATED          STATUS                        PORTS     NAMES
f69078f03887   ubuntu    "/bin/bash"   16 minutes ago   Exited (137) 28 seconds ago             stopped-to-runnig
d9eaf0bac38d   ubuntu    "/bin/bash"   50 minutes ago   Exited (137) 47 minutes ago             running-to-stopped-stop

### Container no estado de running (executando ) para paused

Estado de pause vai manter todos os processos daquele container, pois ao pausar um container, apenas "congelamos ele". Ou seja, ele mantem o container e todos os processos da sua árvore de processos congelados

```bash
# colocando para executar um novo container
docker run --name run-to-paused -dit ubuntu

# pausando um container
docker pause nome_container or id_container

# renomeando o nome do container criado,executado,pausado
docker rename running-to-pause pause-to-running

# reativando o nosso container pausado
docker unpause pause-to-running

# O -d diz: Rode  o container em segundo plano (background) e não me mantenha conectado ao terminal dele
```

Vai retornar algom como no STATUS: Up 52 minutes (Paused)

CONTAINER ID   IMAGE     COMMAND       CREATED          STATUS                        PORTS     NAMES
f69078f03887   ubuntu    "/bin/bash"   16 minutes ago   Exited (137) 28 seconds ago             stopped-to-runnig
d9eaf0bac38d   ubuntu    "/bin/bash"   50 minutes ago   Exited (137) 47 minutes ago             running-to-stopped-stop
aedbeca8d614   ubuntu    "/bin/bash"   52 minutes ago   Up 52 minutes (Paused)                  running-to-stopped-kill
b3ce628ca70c   ubuntu    "/bin/bash"   53 minutes ago   Created                                 pedantic_wozniak
b2d0a69a0977   ubuntu    "/bin/bash"   55 minutes ago   Created                                 gifted_merkle

### Container do stopped para running or deleted

```bash
# Executando novamente o container que foi matado, terminado, pausado
docker start -ai nome_container or id_container
```

