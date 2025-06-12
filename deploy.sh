
#!/bin/bash

echo "🚀 Iniciando deploy do Infra Tools..."

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
docker-compose down

# Limpar imagens antigas (opcional)
read -p "Deseja limpar imagens antigas? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🧹 Limpando imagens antigas..."
    docker system prune -f
    docker image prune -f
fi

# Build e start dos containers
echo "🔨 Fazendo build e iniciando containers..."
docker-compose up --build -d

# Aguardar containers iniciarem
echo "⏳ Aguardando containers iniciarem..."
sleep 10

# Verificar se os containers estão rodando
echo "🔍 Verificando status dos containers..."
docker-compose ps

# Verificar health check
echo "🏥 Verificando saúde da aplicação..."
sleep 30
docker-compose exec app curl -f http://localhost:8080/ || echo "⚠️  Health check falhou - verificando logs..."

echo "✅ Deploy concluído!"
echo "📱 Aplicação disponível em: http://localhost:8080"
echo "🌐 Acesso externo em: http://$(hostname -I | awk '{print $1}'):8080"
echo "📊 Para ver logs: docker-compose logs -f app"
echo "🛑 Para parar: docker-compose down"
echo "🔧 Para debug: docker-compose exec app sh"
