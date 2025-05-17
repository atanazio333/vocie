# Guia de Implantação - ATANAZIO AI VOICE (Produção)

Este guia contém instruções detalhadas para implantar o sistema ATANAZIO AI VOICE em um ambiente de produção.

## Requisitos de servidor

- Ubuntu 20.04 LTS ou posterior
- Python 3.8+
- Nginx
- Supervisor
- Certificado SSL (Let's Encrypt)
- 2GB RAM mínimo recomendado
- Portas 80/443 (web) e 5038/5060 (Asterisk AMI/SIP) abertas

## Configuração do ambiente

1. Atualize o sistema:
```bash
sudo apt update && sudo apt upgrade -y
```

2. Instale as dependências:
```bash
sudo apt install -y python3-pip python3-dev nginx supervisor build-essential libssl-dev libffi-dev python3-venv certbot python3-certbot-nginx
```

3. Clone o repositório:
```bash
git clone [URL_DO_REPOSITORIO] /opt/atanazio-ai-voice
cd /opt/atanazio-ai-voice
```

4. Configure o ambiente virtual:
```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

5. Crie o arquivo `.env` com as credenciais de produção:
```bash
nano .env
```

Conteúdo do arquivo `.env`:
```
OPENAI_API_KEY=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
EASYVOIP_SECRET=Atnzo#2025
OUTBOUND_NUMBER=351915511725
EASYVOIP_HOST=sip.easyvoip.com
EASYVOIP_PORT=5060
EASYVOIP_USER=atanazio333
HOST=0.0.0.0
PORT=8000
DEBUG=False
```

## Configuração do Supervisor

1. Crie um arquivo de configuração para o Supervisor:
```bash
sudo nano /etc/supervisor/conf.d/atanazio-ai-voice.conf
```

2. Adicione a seguinte configuração:
```ini
[program:atanazio-ai-voice]
command=/opt/atanazio-ai-voice/venv/bin/uvicorn src.api.main:app --host 0.0.0.0 --port 8000
directory=/opt/atanazio-ai-voice
user=www-data
autostart=true
autorestart=true
stopasgroup=true
killasgroup=true
stdout_logfile=/var/log/atanazio-ai-voice/access.log
stderr_logfile=/var/log/atanazio-ai-voice/error.log
```

3. Crie os diretórios de log:
```bash
sudo mkdir -p /var/log/atanazio-ai-voice
sudo chown www-data:www-data /var/log/atanazio-ai-voice
```

4. Recarregue o Supervisor:
```bash
sudo supervisorctl reread
sudo supervisorctl update
```

## Configuração do Nginx

1. Crie um arquivo de configuração Nginx:
```bash
sudo nano /etc/nginx/sites-available/atanazio-ai-voice
```

2. Adicione a seguinte configuração:
```nginx
server {
    listen 80;
    server_name seu-dominio.com;

    location / {
        proxy_pass http://localhost:8000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_cache_bypass $http_upgrade;
    }
}
```

3. Habilite o site:
```bash
sudo ln -s /etc/nginx/sites-available/atanazio-ai-voice /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

4. Configure SSL com Certbot:
```bash
sudo certbot --nginx -d seu-dominio.com
```

## Manutenção e Monitoramento

### Verificação de logs:
```bash
sudo tail -f /var/log/atanazio-ai-voice/error.log
```

### Reinício do serviço:
```bash
sudo supervisorctl restart atanazio-ai-voice
```

### Checagem de status:
```bash
sudo supervisorctl status atanazio-ai-voice
```

## Backup

Crie um script de backup para os dados importantes:
```bash
#!/bin/bash
BACKUP_DIR="/backup/atanazio-ai-voice"
DATE=$(date +%Y%m%d)
mkdir -p $BACKUP_DIR
cp -r /opt/atanazio-ai-voice/.env $BACKUP_DIR/env-$DATE
# Adicione outros arquivos ou diretórios importantes
```

## Segurança

1. Configure um firewall (UFW):
```bash
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 5060/tcp  # Para SIP
sudo ufw allow 5038/tcp  # Para Asterisk AMI
sudo ufw enable
```

2. Implementar autenticação para o painel de administração (opcional):
```bash
# Adicionar código de autenticação no painel web
```

## Resolução de problemas comuns

1. Serviço não inicia:
   - Verificar logs: `sudo tail -f /var/log/atanazio-ai-voice/error.log`
   - Verificar status supervisor: `sudo supervisorctl status`

2. Problemas de conexão com Asterisk:
   - Testar conectividade: `telnet sip.easyvoip.com 5060`
   - Verificar credenciais no arquivo `.env`

3. Elevado uso de CPU/memória:
   - Verificar recursos: `top` ou `htop`
   - Reiniciar o serviço: `sudo supervisorctl restart atanazio-ai-voice` 