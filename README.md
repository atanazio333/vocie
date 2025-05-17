# ATANAZIO AI VOICE

Sistema avançado de chamadas telefônicas automatizadas com IA conversacional para venda de franquias. Integração com síntese de voz usando OpenAI TTS, sistema de telemarketing com EasyVoIP/Asterisk e agendamento automático com Google Agenda.

## Funcionalidades Principais

- **Chamadas em Massa**: Upload de listas de contatos via CSV para campanhas automatizadas
- **IA Conversacional**: Sistema inteligente que adapta o discurso com base nas emoções e perfil do lead
- **Análise de Reações**: Detecção automática de sentimentos e respostas personalizadas
- **Gerenciamento de Campanhas**: Painel completo para controle de campanhas (pausar, retomar, encerrar)
- **Integração com Google Agenda**: Agendamento automático de reuniões após chamadas bem-sucedidas
- **Múltiplos Scripts de Venda**: Adaptação dinâmica do discurso conforme a etapa da conversa

## Requisitos

- Python 3.8+
- Conta na OpenAI
- Conta EasyVoIP (com número português ativo)
- Servidor Asterisk configurado
- Conta Google (Google Agenda)
- Arquivo de credenciais OAuth2 do Google (`credentials.json`)

## Instalação

1. Clone o repositório:
```bash
git clone [URL_DO_REPOSITORIO]
cd ATANAZIO-AI-VOICE
```

2. Instale as dependências:
```bash
pip install -r requirements.txt
```

3. Configure as variáveis de ambiente:
Crie um arquivo `.env` na raiz do projeto com as seguintes variáveis:
```
OPENAI_API_KEY=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
EASYVOIP_SECRET=Atnzo#2025
OUTBOUND_NUMBER=351915511725
EASYVOIP_HOST=sip.easyvoip.com
EASYVOIP_PORT=5060
EASYVOIP_USER=atanazio333
HOST=0.0.0.0
PORT=8000
DEBUG=True
```

4. Adicione o arquivo de credenciais do Google:
- Baixe o arquivo `credentials.json` do Google Cloud Console (OAuth2 Client ID)
- Coloque o arquivo na raiz do projeto

## Uso

1. Inicie o servidor:
```bash
python -m uvicorn src.api.main:app --reload
```

2. Acesse o painel web:
```
http://localhost:8000
```

## Funcionalidades Detalhadas

### Chamadas Individuais
- Permite fazer chamadas para números específicos
- Escolha de mensagem personalizada
- Monitoramento em tempo real do status

### Campanhas em Massa
1. **Criar Campanha**:
   - Defina um nome para a campanha
   - Faça upload de um arquivo CSV com números de telefone
   - Escreva a mensagem a ser utilizada
   - Configure o intervalo entre chamadas

2. **Gerenciar Campanhas**:
   - Visualize estatísticas em tempo real
   - Pause, retome ou encerre campanhas conforme necessário
   - Analise métricas de conversão

### Análise de Reações
- Sistema detecta automaticamente:
  - Reações positivas
  - Objeções e dúvidas
  - Hesitação
  - Medo e insegurança
- Adapta o script de resposta dinamicamente

## Endpoints da API

- `POST /call`: Inicia uma nova chamada telefônica
- `GET /call-status/{call_id}`: Consulta o status de uma chamada
- `POST /end-call/{call_id}`: Encerra uma chamada ativa
- `POST /campaign`: Cria uma nova campanha de chamadas em massa
- `POST /campaign/{campaign_id}/pause`: Pausa uma campanha ativa
- `POST /campaign/{campaign_id}/resume`: Retoma uma campanha pausada
- `POST /campaign/{campaign_id}/stop`: Encerra uma campanha
- `GET /health`: Verifica o status do servidor

## Estrutura do Projeto

```
src/
├── ai/
│   └── gpt_handler.py     # Gerenciamento da IA conversacional e análise emocional
├── api/
│   └── main.py            # API principal e endpoints
├── scripts/
│   └── google_calendar.py # Integração com Google Agenda
├── static/                # Arquivos estáticos (CSS, JS)
├── templates/             # Templates HTML
├── telephony/
│   ├── easyvoip_handler.py # Integração com EasyVoIP/Asterisk
│   └── twilio_handler.py   # Integração alternativa com Twilio
├── voice/
│   └── voice_handler.py    # Gerenciamento de síntese de voz
└── config.py               # Configurações do sistema
```

## Suporte e Contribuições

Para suporte ou dúvidas, entre em contato com a equipe ATANAZIO.

## Implantação em Produção

Para instruções detalhadas sobre implantação em ambiente de produção, consulte o arquivo [README.prod.md](README.prod.md).

Execute o script de inicialização para produção:
```bash
# Em ambiente Linux
sudo chmod +x start_prod.sh
sudo ./start_prod.sh
```