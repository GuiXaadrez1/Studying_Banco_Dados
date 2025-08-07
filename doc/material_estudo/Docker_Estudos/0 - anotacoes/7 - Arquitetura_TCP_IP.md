# Introdução

A arquitetura TCP/IP é o conjunto de protocolos responsável por viabilizar a comunicação entre computadores em redes, como a internet. Ela é um modelo conceitual e prático que define como os dados são encapsulados, transmitidos e recebidos entre sistemas distintos.

Este documento tem como objetivo apresentar essa arquitetura de forma intuitiva e explicativa, destacando cada camada, seus principais protocolos e as portas lógicas utilizadas na comunicação.

## 🧱 Estrutura da Arquitetura TCP/IP

A arquitetura TCP/IP é dividida em 4 camadas, cada uma com responsabilidades específicas:

- Camada de Aplicação (Application Layer)

- Camada de Transporte (Transport Layer)

- Camada de Internet (Internet Layer)

- Camada de Acesso à Rede (Network Access Layer)

Essa estrutura é mais simples que o modelo OSI (com 7 camadas), mas cobre todas as funcionalidades necessárias para comunicação em redes.

## Camada de Aplicação

✨ Função: Responsável por fornecer interfaces e serviços de rede diretamente às aplicações dos usuários (ex: navegadores, e-mails, FTPs, etc.).

Principais Protocolos e Portas:

| Protocolo  | Função                                 | Porta Padrão              |
| ---------- | -------------------------------------- | ------------------------- |
| **HTTP**   | Acesso à web (navegadores)             | 80                        |
| **HTTPS**  | Acesso seguro à web                    | 443                       |
| **FTP**    | Transferência de arquivos              | 21 (controle), 20 (dados) |
| **SMTP**   | Envio de e-mails                       | 25, 587                   |
| **POP3**   | Recebimento de e-mails                 | 110                       |
| **IMAP**   | Acesso remoto a e-mails                | 143, 993                  |
| **DNS**    | Resolução de nomes (domínios ↔ IPs)    | 53                        |
| **SSH**    | Acesso remoto seguro (shell)           | 22                        |
| **Telnet** | Acesso remoto sem segurança (obsoleto) | 23                        |

## Camada de Transporte

✨ Função: Garante a entrega dos dados entre aplicações finais, podendo ser orientada à conexão (TCP) ou não (UDP).

### Protocolos:

| Protocolo | Tipo de Serviço         | Características                                |
| --------- | ----------------------- | ---------------------------------------------- |
| **TCP**   | Orientado à conexão     | Garantia de entrega, ordem e integridade       |
| **UDP**   | Não orientado à conexão | Mais rápido, sem garantias de entrega ou ordem |

Exemplos de uso:

- TCP: HTTP, HTTPS, SMTP, FTP, SSH

- UDP: DNS, DHCP, SNMP, VoIP, jogos online

## Camada de Internet

✨ Função: Responsável pelo endereçamento lógico (IP) e roteamento de pacotes entre redes diferentes.

| Protocolo | Função                                        |
| --------- | --------------------------------------------- |
| **IP**    | Endereçamento e roteamento                    |
| **ICMP**  | Diagnóstico e controle (ex: ping, traceroute) |
| **ARP**   | Mapeamento de IP para MAC                     |
| **IGMP**  | Gerência de grupos multicast                  |

## Camada de Acesso à Rede

✨ Função: Define os meios físicos e protocolos para acesso ao meio de transmissão (cabo, Wi-Fi, etc.).

### 🔧 Protocolos e Tecnologias:

- Ethernet: 

Ethernet é o padrão mais usado para redes locais (LANs), definido pelo IEEE 802.3. Utiliza topologia estrela e acesso ao meio via CSMA/CD (Carrier Sense Multiple Access with Collision Detection), embora em redes modernas com switches, as colisões sejam praticamente inexistentes.

🔍 Características:
Velocidades: 10 Mbps, 100 Mbps (Fast Ethernet), 1 Gbps, 10 Gbps, 40 Gbps, 100 Gbps.

Cabo: Geralmente cabos de par trançado (UTP/STP) ou fibra óptica.

Endereçamento: Usa MAC Address (48 bits).

🧠 Funcionamento: Cada quadro Ethernet possui: preâmbulo, endereço MAC de origem e destino, tipo, dados e FCS (Frame Check Sequence).

Sem colisões em redes com switches (full duplex).

Altamente escalável e compatível com a maioria dos equipamentos.

- Wi-Fi (IEEE 802.11): 

É o padrão para redes sem fio locais (WLANs), definido pelo IEEE 802.11. Opera na camada de enlace com suporte à mobilidade, utilizando espectros de rádio nas faixas de 2,4 GHz e 5 GHz.

🔍 Características:

Padrões: 802.11a/b/g/n/ac/ax (Wi-Fi 6).

Velocidades: De 11 Mbps (802.11b) até mais de 9 Gbps (Wi-Fi 6E).

Acesso ao meio: CSMA/CA (Carrier Sense Multiple Access with Collision Avoidance).

Segurança: WPA2/WPA3.

🧠 Funcionamento:

Cada estação negocia com um ponto de acesso.

Controla a colisão evitando-a (CA), não detectando-a como no Ethernet.

Inclui funcionalidades como roaming e múltiplos canais.


- PPP (Point-to-Point Protocol):

Protocolo de enlace para comunicação ponto-a-ponto, muito utilizado em conexões discadas, links seriais e VPNs. Define encapsulamento e autenticação.

🔍 Características:

Protocolo da camada 2 (enlace).

Usa autenticação: PAP (Password Authentication Protocol) e CHAP (Challenge Handshake Authentication Protocol).

Suporta encapsulamento de pacotes IP, IPv6, AppleTalk, etc.

🧠 Funcionamento:

Cada quadro PPP contém: Flag, Address, Control, Protocol, Payload, CRC.

Estabelece conexão com negociação de parâmetros via LCP (Link Control Protocol) e autenticação.

Depois usa NCPs (Network Control Protocols) para configurar a camada de rede.

- Frame Relay:

Tecnologia WAN de comutação de pacotes, usada para interligar redes LANs em grandes distâncias, substituindo parcialmente os links ponto-a-ponto.

🔍 Características:

Conexões virtuais (PVCs – Permanent Virtual Circuits).

Baixa sobrecarga, ideal para transmissão rápida.

Taxas de até 45 Mbps.

🧠 Funcionamento:

Usa uma interface de rede e canais lógicos identificados por DLCIs.

Não faz correção de erros — espera que camadas superiores lidem com isso.

Protocolo leve, mas obsoleto devido ao advento de MPLS, Metro Ethernet e VPNs.

- FDDI:

Padrão para redes locais baseado em fibra óptica, com topologia anel duplo e tolerância a falhas.

🔍 Características:

Velocidade de até 100 Mbps.

Topologia de anel com redundância.

Usa o protocolo Token Passing (sem colisões).

🧠 Funcionamento:

Dois anéis: primário (dados) e secundário (reserva).

Um token circula na rede; só quem tem o token pode transmitir.

Quando há falha no anel primário, o anel secundário assume automaticamente.

- Token Ring:

Tecnologia LAN criada pela IBM que usa um anel lógico onde o acesso ao meio é controlado por um token.

🔍 Características:

Velocidades de 4 ou 16 Mbps.

Topologia física estrela, lógica em anel.

Acesso ao meio controlado: somente quem possui o token transmite.

🧠 Funcionamento:

Um token (pequeno pacote especial) circula no anel.

A estação que deseja transmitir deve esperar o token livre.

Tecnologia foi substituída pelo Ethernet por limitações de custo e escalabilidade.

Essa camada abrange o que o modelo OSI define como Camada Física + Camada de Enlace.

## 🎯 O que são Portas Lógicas?

As portas lógicas são identificadores numéricos usados para diferenciar múltiplas conexões simultâneas entre dois hosts. Elas operam na camada de transporte e permitem que vários serviços possam funcionar simultaneamente em um mesmo endereço IP.

Faixas de portas:

| Faixa       | Nome                               | Uso Comum                             |
| ----------- | ---------------------------------- | ------------------------------------- |
| 0–1023      | Portas Bem Conhecidas (Well-Known) | Protocolos padrão como HTTP, FTP, SSH |
| 1024–49151  | Portas Registradas                 | Aplicações de usuário e serviços      |
| 49152–65535 | Portas Dinâmicas/Efêmeras          | Usadas temporariamente pelos sistemas |

##  Exemplo de Comunicação HTTP

Você acessa https://exemplo.com.

O navegador realiza uma resolução DNS para obter o IP.

Uma conexão TCP é aberta com o IP na porta 443.

O servidor responde e inicia a transmissão de dados HTTPS.

A conexão é encerrada após a transferência.

## Tabela Resumo de Protocolos e Portas

| Camada     | Protocolo | Porta(s) | Descrição                      |
| ---------- | --------- | -------- | ------------------------------ |
| Aplicação  | HTTP      | 80       | Navegação web                  |
| Aplicação  | HTTPS     | 443      | Navegação segura               |
| Aplicação  | DNS       | 53       | Resolução de nomes             |
| Aplicação  | FTP       | 20/21    | Transferência de arquivos      |
| Aplicação  | SSH       | 22       | Acesso remoto seguro           |
| Transporte | TCP       | —        | Confiável, orientado à conexão |
| Transporte | UDP       | —        | Rápido, não confiável          |
| Internet   | IP        | —        | Roteamento entre redes         |
| Internet   | ICMP      | —        | Diagnóstico (ping, etc.)       |
| Acesso     | Ethernet  | —        | Comunicação local por cabo     |

## Conclusão

A arquitetura TCP/IP é fundamental para a internet moderna. Ela organiza a comunicação em camadas independentes e especializadas, facilitando o desenvolvimento de sistemas distribuídos.

Ao entender os protocolos e suas respectivas portas lógicas, você terá uma base sólida para diagnosticar problemas de rede, configurar serviços, trabalhar com containers e muito mais.