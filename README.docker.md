
# Infra Tools - Setup Docker

## Pré-requisitos

Certifique-se de ter Docker e Docker Compose instalados na sua VM:
- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

## 🚀 Deploy Rápido

### Para Produção
```bash
# Dar permissão de execução
chmod +x deploy.sh

# Executar deploy
./deploy.sh
```

### Para Desenvolvimento
```bash
# Dar permissão de execução
chmod +x dev.sh

# Executar ambiente de desenvolvimento
./dev.sh
```

## 📋 Deploy Manual

### Desenvolvimento
```bash
# Build e start dos containers
docker-compose -f docker-compose.dev.yml up --build

# Ou em background
docker-compose -f docker-compose.dev.yml up -d --build
```

### Produção
```bash
# Build e start
docker-compose up --build

# Ou em background
docker-compose up -d --build
```

A aplicação estará disponível em `http://localhost:8080`

## 💾 Persistência de Dados

### Localização dos Dados
- **Desenvolvimento**: Volume `database_data` mapeado para `/app/database`
- **Produção**: Volume `database_data` mapeado para `/app/database`

### Backup dos Dados
```bash
# Criar backup
docker run --rm -v $(pwd)/database_data:/data -v $(pwd):/backup alpine tar czf /backup/backup-$(date +%Y%m%d-%H%M%S).tar.gz -C /data .

# Restaurar backup
docker run --rm -v $(pwd)/database_data:/data -v $(pwd):/backup alpine tar xzf /backup/backup-YYYYMMDD-HHMMSS.tar.gz -C /data
```

### Dados de Exemplo
Na primeira execução, o sistema irá criar automaticamente:
- 1 organização padrão
- 1 time de desenvolvimento
- Estrutura de dados vazia pronta para uso

## 🔧 Comandos Úteis

```bash
# Ver logs em tempo real
docker-compose logs -f app

# Ver logs do desenvolvimento
docker-compose -f docker-compose.dev.yml logs -f app

# Parar containers
docker-compose down

# Parar containers de desenvolvimento
docker-compose -f docker-compose.dev.yml down

# Limpar volumes (⚠️ apaga dados do banco)
docker-compose down -v

# Rebuild sem cache
docker-compose build --no-cache

# Entrar no container
docker-compose exec app sh

# Verificar status dos containers
docker-compose ps

# Ver uso de recursos
docker stats
```

## 🐛 Resolução de Problemas

### Container não inicia
```bash
# Ver logs detalhados
docker-compose logs app

# Verificar se as portas estão livres
netstat -tulpn | grep :8080
# ou
lsof -i :8080
```

### Erro de permissão no banco
```bash
# Recriar volume do banco
docker-compose down -v
docker-compose up --build
```

### Problemas com dependências
```bash
# Limpar tudo e rebuildar
docker-compose down
docker system prune -f
docker-compose build --no-cache
docker-compose up
```

### Performance lenta
```bash
# Verificar recursos da VM
docker system df
docker system events

# Limpar recursos não utilizados
docker system prune -a
```

## 🖥️ Configuração da VM

### Requisitos Mínimos
- **CPU**: 2 cores
- **RAM**: 4GB
- **Disco**: 20GB livres
- **SO**: Ubuntu 20.04+ / CentOS 8+ / Debian 11+

### Portas Necessárias
- **8080**: Aplicação web
- **22**: SSH (para acesso remoto)

### Firewall
```bash
# Ubuntu/Debian
sudo ufw allow 8080
sudo ufw allow 22

# CentOS/RHEL
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --permanent --add-port=22/tcp
sudo firewall-cmd --reload
```

## 🔒 Segurança

### Atualizações Automáticas
```bash
# Configurar restart automático dos containers
docker-compose up -d --restart=unless-stopped
```

### Backup Automático (Crontab)
```bash
# Editar crontab
crontab -e

# Adicionar linha para backup diário às 2h
0 2 * * * cd /caminho/para/projeto && docker run --rm -v database_data:/data -v $(pwd):/backup alpine tar czf /backup/backup-$(date +%Y%m%d).tar.gz -C /data .
```

## 📊 Monitoramento

### Logs
```bash
# Logs em tempo real com timestamp
docker-compose logs -f -t app

# Logs das últimas 100 linhas
docker-compose logs --tail=100 app
```

### Status da Aplicação
```bash
# Health check manual
curl -f http://localhost:8080 || echo "Aplicação não está respondendo"

# Status dos containers
docker-compose ps
```

## 🔄 Atualizações

### Atualizar a Aplicação
```bash
# Fazer backup primeiro
./backup.sh

# Parar aplicação
docker-compose down

# Atualizar código (git pull ou copiar novos arquivos)
git pull

# Rebuildar e iniciar
docker-compose up --build -d
```

### Rollback em Caso de Problemas
```bash
# Voltar para versão anterior do código
git checkout HEAD~1

# Rebuildar
docker-compose up --build -d
```

## 📱 Acesso Remoto

### Acessar de Outras Máquinas
A aplicação estará disponível em:
- `http://IP_DA_VM:8080`
- Substitua `IP_DA_VM` pelo IP real da sua máquina virtual

### Configurar Domínio (Opcional)
1. Configure seu DNS para apontar para o IP da VM
2. Use um proxy reverso como Nginx se necessário
3. Configure SSL/TLS para HTTPS

## 📞 Suporte

### Arquivos de Log Importantes
- Container logs: `docker-compose logs app`
- System logs: `/var/log/docker.log`
- Application data: Volume `database_data`

### Informações do Sistema
```bash
# Versão do Docker
docker --version
docker-compose --version

# Info do sistema
docker system info

# Uso de espaço
docker system df
```
