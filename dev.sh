
#!/bin/bash

echo "🛠️ Iniciando ambiente de desenvolvimento..."

# Verificar se Docker está rodando
if ! docker info >/dev/null 2>&1; then
    echo "❌ Docker não está rodando. Por favor, inicie o Docker primeiro."
    exit 1
fi

# Verificar se a porta 8080 está livre
if lsof -Pi :8080 -sTCP:LISTEN -t >/dev/null; then
    echo "⚠️  Porta 8080 está em uso. Parando containers existentes..."
fi

# Parar containers existentes
echo "🛑 Parando containers existentes..."
docker-compose -f docker-compose.dev.yml down

# Build e start dos containers de desenvolvimento
echo "🔨 Fazendo build e iniciando containers de desenvolvimento..."
docker-compose -f docker-compose.dev.yml up --build

echo "✅ Ambiente de desenvolvimento iniciado!"
echo "📱 Aplicação disponível em: http://localhost:8080"
echo "🌐 Acesso externo em: http://$(hostname -I | awk '{print $1}'):8080"
echo "🔄 Hot reload ativo - mudanças no código serão refletidas automaticamente"
echo "📊 Para ver logs: docker-compose -f docker-compose.dev.yml logs -f app"
echo "🛑 Para parar: docker-compose -f docker-compose.dev.yml down"
