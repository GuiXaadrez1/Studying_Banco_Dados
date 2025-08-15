# definindo a nossa imagem: será Python 3.11 sobre Alpine Linux versão 3.22 (leve e otimizada).
FROM python:3.11-alpine3.22

# Definindo um arquivo de trabalho
WORKDIR /test_integration

# copiando pasta da aplicação na máquina host para o container
COPY integrations/ .

# atualizadno o gerenciador de pacotes pip
RUN python -m pip install --upgrade pip

# instalando os nossos pacotes
RUN pip install -r requirements.txt

# Executando um comando padrão assim que o container subir
CMD ["python","db_connect.py"]