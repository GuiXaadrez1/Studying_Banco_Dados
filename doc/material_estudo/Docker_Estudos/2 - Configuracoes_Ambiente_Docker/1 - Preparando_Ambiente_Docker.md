# Introdução 
Este documento visa explicar passo a passo a nossa preparação de ambiente Docker para usuários Windows e Linux

## Primeiro com Windows 
Vamos usar o WSL (WINDOWS SUBSYSTEMS FOR LINUX) com a distribuição da UBUNTU

### O que é o WSL? 

O Subsistema do Windows para Linux (WSL) é um recurso do Windows que permite executar um ambiente Linux em seu computador Windows, sem a necessidade de uma máquina virtual separada ou inicialização dupla. O WSL foi projetado para fornecer uma experiência contínua e produtiva para desenvolvedores que desejam usar o Windows e o Linux ao mesmo tempo.

### Tipos de WSL 

WSL 1: 
    - Tradução (camada de compatibilidade)
    - Basicamente ele traduz os comandos linux em windows

WSL 2:
    - Subsistema completo
    - Hypervisor.Hyper-V (suporte a máquina virtual)

### Como instalar o WSL

- Antes de instalar, use o comando: win + r e escreva no execute: winver para ver a build do seu sistema operacional e se ele atende os pré-requisitos na documentação de instalação https://learn.microsoft.com/pt-br/windows/wsl/install

**Primeiro passo é instalar o windows terminal na loja da microsoft** - dentro da loja em pesquisar você digita: Windows Terminal - faça o download

**observações:** geralmente ele vem por padrão

**Segundo passo, no seu power shell use o comando:**
```PowerShell
wsl --install
```

vai retornar algo como:

```PowerShell
Baixando: Subsistema do Windows para Linux 2.5.9
Instalando: Subsistema do Windows para Linux 2.5.9
Subsistema do Windows para Linux 2.5.9 foi instalado.
A operação foi concluída com êxito.
Baixando: Ubuntu
Instalando: Ubuntu
Distribuição instalada com êxito. Ele pode ser iniciado por meio de 'wsl.exe -d Ubuntu'
Iniciando Ubuntu...
Provisioning the new WSL instance Ubuntu
This might take a while...
Create a default Unix user account: nome_seu_usuário_linux
New password: sua_senha
Retype new password: repetir_sua_senha
passwd: password updated successfully

To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.
```

### 🔎 Dica importante
Toda vez que abrir o WSL, ele já vai logar com esse usuário.

Se precisar abrir de novo:
    wsl ou wsl -d Ubuntu no cmd ou PowerShell.

Para garantir que está rodando WSL 2: execute:

```bash
wsl --list --verbose
```

e confira se a coluna VERSION mostra 2.

### Próximo passo recomendado

Agora que o Ubuntu está pronto, configure o ambiente:

1️⃣ Atualize pacotes:

Você verá o seu nome de usuário (ex.: guilherme).

Atualizar o sistema
Primeiro comando essencial em qualquer Linux novo:

```bash
sudo apt update && sudo apt upgrade -y
```

➡️ O sudo faz você rodar como administrador.
➡️ O apt update atualiza o índice de pacotes.
➡️ O apt upgrade instala as atualizações.

Ele vai pedir sua senha:
Digite a senha que criou antes. O terminal não mostra nada enquanto digita — isso é normal.

2️⃣ Instalar utilitários básicos

Instale ferramentas de desenvolvimento úteis:

```bash
sudo apt install -y build-essential curl git
sudo apt install net-tools
```

🔹 3️⃣ Ver se está tudo certo

No seu terminal do Ubuntu, digite:

```bash
whoami
```

🔹 4️⃣ Verificar versão do Linux
Para confirmar sua distro e kernel:

```bash
uname -a
lsb_release -a
```

## Referências

https://learn.microsoft.com/pt-br/windows/wsl/about
doc_instalação - https://learn.microsoft.com/pt-br/windows/wsl/install

