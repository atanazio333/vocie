#!/bin/bash

# Script de inicialização para ambiente de produção
# ATANAZIO AI VOICE

echo "Iniciando ATANAZIO AI VOICE em modo produção..."

# Verifica se está rodando como sudo
if [ "$EUID" -ne 0 ]; then
  echo "Por favor, execute este script como root (sudo)"
  exit 1
fi

# Verifica se o arquivo .env existe
if [ ! -f .env ]; then
  echo "Arquivo .env não encontrado! Criando um arquivo de exemplo..."
  cat > .env << EOL
OPENAI_API_KEY=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
EASYVOIP_SECRET=Atnzo#2025
OUTBOUND_NUMBER=351915511725
EASYVOIP_HOST=sip.easyvoip.com
EASYVOIP_PORT=5060
EASYVOIP_USER=atanazio333
HOST=0.0.0.0
PORT=8000
DEBUG=False
EOL
  echo "Arquivo .env criado. Por favor, verifique as configurações antes de continuar."
  exit 1
fi

# Verifica se o ambiente virtual existe
if [ ! -d "venv" ]; then
  echo "Ambiente virtual não encontrado. Criando..."
  python3 -m venv venv
  echo "Instalando dependências..."
  ./venv/bin/pip install -r requirements.txt
fi

# Ativa o ambiente virtual
source venv/bin/activate

# Verifica a conexão com EasyVoIP
echo "Testando conexão com EasyVoIP..."
nc -z -w5 $(grep EASYVOIP_HOST .env | cut -d= -f2) $(grep EASYVOIP_PORT .env | cut -d= -f2) 2>/dev/null
if [ $? -ne 0 ]; then
  echo "AVISO: Não foi possível conectar ao servidor EasyVoIP. Verifique as configurações."
  echo "Pressione ENTER para continuar mesmo assim ou CTRL+C para cancelar."
  read
fi

# Inicia o servidor em modo produção
echo "Iniciando o servidor..."
export $(grep -v '^#' .env | xargs)
exec uvicorn src.api.main:app --host $HOST --port $PORT --workers 4 