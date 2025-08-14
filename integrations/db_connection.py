'''
Crie um código que realiza a integração com o banco de dados postgres e permite o usuário
pesquisar via console o nome do vendendor ativo e com base no nome pesquisa retorne a o total
de vendas que ele fez naquele dia.
'''

# Importando as nossas libs

from dotenv import load_dotenv # puxa as variáveis de ambiente do arquivo .env
import psycopg2 # faz conexão com o banco de dados
import os # lib nativa para manipulação de diretórios

# carregando as variáveis de ambiente
load_dotenv()

# verificando se puxei todas as variáveis de ambiente
# print(os.getenv("DATABASE"),os.getenv("USER"),os.getenv("PASSWORD"))

# Criando conexaão com o banco de dados sisvendas

print("Realizando conexão com o banco de dados")

try:
    
    # with estrutura de controle que facilita o gerenciamento de recursos, 
    # como arquivos, conexões de banco de dados, e outros objetos que precisam ser abertos 
    # e fechados.
    
    # Dica: Usar o with apenas para cursor e não para abrir conexão
    def connection():
        conn = psycopg2.connect(
            database=os.getenv('DATABASE'),
            user=os.getenv('USER'),
            password=os.getenv('PASSWORD'),
            port = os.getenv("PORT")
        )

        # declarando o cursos 
        # lembrando que o with vai fechar o cursor automaticamente
        # sem a necessidade de fazer isso manualmente com método cur.close()
        with conn.cursor() as cur:
            # Selecionado todas as informações da tabela vendas
            
            # fazendo um select simples com a tabela do vendedor
            def consultar_vendedor_ativos():
                query = "SELECT codfun, nome, email FROM vendedor WHERE statusdelete = FALSE"
                cur.execute(query)
                resultado = cur.fetchall()
                
                # craindo uma lista vazia
                vendedores = []

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
                    vendedores.append(at_dicio)

                    # realizando commits das alterações da base de dados
                    conn.commit()
                    
                return vendedores
            
            # fazendo uma função que retornar dados de um select simples
            def info_vendas():  
                query="SELECT * FROM venda ORDER BY preco DESC"           
                cur.execute(query)
                
                resultado = cur.fetchall()
                
                return resultado
            
            '''
            print()
            # iteração básica
            for linha in info_vendas():
                print(list(linha))
            '''    
        
        # Fechando conexão com o banco de dados
        conn.close()
        
except Exception as error:
    print("Aconteceu algum erro aqui: ", error)


if __name__ == "__main__":

    # Realizando conexão com o banco de dados
    connection()


