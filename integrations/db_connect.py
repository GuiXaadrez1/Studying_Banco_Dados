'''
Crie um código que realiza a integração com o banco de dados postgres e permite o usuário
pesquisar via console o nome do vendendor ativo e com base no nome pesquisa retorne a o total
de vendas que ele fez naquele dia.
'''

# Importando as nossas libs

from dotenv import load_dotenv # puxa as variáveis de ambiente do arquivo .env
import psycopg2 # faz conexão com o banco de dados
from psycopg2 import OperationalError # para fazermos debug
import time # para podemos fazer um descanso de 1 segundo
import os # lib nativa para manipulação de diretórios
import sys

# carregando as variáveis de ambiente
load_dotenv()

# verificando se puxei todas as variáveis de ambiente
# print(os.getenv("DATABASE"),os.getenv("USER"),os.getenv("PASSWORD"))

# Criando conexaão com o banco de dados sisvendas

print("Realizando conexão com o banco de dados")


# DICAS

# with estrutura de controle que facilita o gerenciamento de recursos, 
# como arquivos, conexões de banco de dados, e outros objetos que precisam ser abertos 
# # e fechados automáticamente sem definir manualmente.

# O idealmente usamos o with apenas para cursor e não para abrir conexão
    
# Criando a nossa classe
class ConnectionDatabase:

    # definindo o nosso método construtor
    def __init__(self):
        
        while True:
            try:
                # conexão privada a classe (apenas os métodos internos da classe tem acesso a esses atributos)
                self.__conn = psycopg2.connect(
                    host=os.getenv("HOST"),
                    port=os.getenv("PORT"),
                    user=os.getenv("POSTGRES_USER"),
                    password=os.getenv("POSTGRES_PASSWORD"),
                    database=os.getenv("POSTGRES_DB")
                )
                # se conectar com sucesso, sai do loop
                break
            except OperationalError:
                print("Banco ainda não está pronto, aguardando 1s...")
                time.sleep(1)
        
    # método que realiza a consulta referente a todas as informações de um vendedor
    def consultar_vendedor_ativos(self):
        with self.__conn.cursor() as cur:
            query = "SELECT codfun, nome, email FROM vendedor WHERE statusdelete = FALSE"
            cur.execute(query)
            resultado = cur.fetchall()
        
            # criando uma lista de discionário vazio
            vendedores = []

            # iterando tuplas, linhas, registros, rows/row
            for row in resultado:
                # desempacota a tupla
                # basicamente vamos atribuir os elementos da tupla diretamente em variáveis.
                codfun, nome, email = row
                
                # Craindo dicionário para comportar os dados
                at_dicio = {
                    "Código Funcionário": codfun,
                    "Nome": nome,
                    "Email": email
                }
                
                # colocando o dicionário ao final da nossa lista
                vendedores.append(at_dicio)

                # realizando commits das alterações da base de dados
                self.__conn.commit()
                                
            # Fechando conexão com o banco de dados
            # conn.close() essa é a corma manual de fazer isso sem with
            
            # Fechando conexão com o banco de dados
            # self.__conn.close() 
            
            return vendedores

    # criando método publico que permite consultar o 
    def consultar_produto_total_venda_vendedor(self,nome_vendedor="José Antônio")->list:
        
        # acessando os atributos privados para abrir conexão
        with self.__conn.cursor() as cur:
            
            # definindo a nossa query
            query = '''
                SELECT 
                    vd.nome AS nome_vendedor,
                    pd.nome AS nome_produto,
                    SUM(venda.preco * venda.qtd) AS total_venda
                FROM venda
                INNER JOIN public.vendedor AS vd 
                    ON vd.idvendedor = venda.idvendedor
                INNER JOIN public.produto AS pd 
                    ON pd.idproduto = venda.idproduto
                WHERE vd.nome = %s 
                GROUP BY vd.nome, pd.nome;
            ''' 
            
            # usando a forma do operador % para formatar string
            cur.execute(query, (nome_vendedor,))
            
            # pegando uma lista de tuplas
            registros = cur.fetchall()
            
            # definindo uma lista vazia de resultados
            resultados = []
            
            for row in registros:
                
                # desenpacotando a tupla, modo1
                # nome_vendedor,*resto = row
                
                # desenpacotando tupla modo 2
                nome_vendedor,nome_produto,total_venda = row

                # quando usamos a empressão estrelada para pega o resto de infomações da tupla
                # o retorno é uma lista
                #print(resto) 
                
                 # Usando isso para fazer uma formatação simples
                '''print('''
                '''| Nome vendedor    | Nome produto          | Total venda    |
                   | %s | %s | %s       |
                   % (nome_vendedor, nome_produto, total_venda))'''

                # realizando casting explícitamente
                dicio_info = {
                    "Nome Vendedor(a)":str(nome_vendedor),
                    "Nome Produto":str(nome_produto),
                    "Total de vendas realizada":str(total_venda)
                }
                
                resultados.append(dicio_info)
            
            # Colocando os resultados fora do for para não dar b.o     
            return resultados
            
            # realizando commits das alterações da base de dados
            #self.__conn.commit()

            # Fechando conexão com o banco de dados
            # self.__conn.close() 
            
            

# colcando isso para não dar problema na hora de executar com outros arquivos
if __name__ == "__main__":
    
    while True:
        try:
            # Materializando a nossa conexão com o banco de dados
            db = ConnectionDatabase()
            break
        except OperationalError:
            print("Banco ainda não está pronto, aguardando 1s...")
            time.sleep(1)
 
    # pegando a lista de dicionários
    lista = db.consultar_vendedor_ativos()
    
    # Listando todos os Funcionários e suas informações
    print("\n\nCódigo Funcionário |  Nome            | Email")
    for elementos in lista:
        print(
            elementos.get("Código Funcionário"), "            | ", elementos.get("Nome"), "   | ", elementos.get("Email")
        )
    
    print("\n-----------------------------------------------------------------------------------------------------------\n")

    consultar_resultados_vendas = db.consultar_produto_total_venda_vendedor('José Antônio')
    
    print("Nome Vendedor(a)  | Nome Produto        | Total Vendas ")
    for elementos in consultar_resultados_vendas:
        print(
            elementos.get("Nome Vendedor(a)"), " | ", elementos.get("Nome Produto"), " | ", elementos.get("Total de vendas realizada")
        )