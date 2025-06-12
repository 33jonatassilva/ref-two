
@echo off
echo 🚀 Iniciando deploy do Infra Tools...

REM Verificar se Docker está rodando
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker não está rodando. Por favor, inicie o Docker Desktop primeiro.
    pause
    exit /b 1
)

REM Verificar se a porta 8080 está livre
netstat -an | findstr :8080 >nul
if %errorlevel% equ 0 (
    echo ⚠️  Porta 8080 está em uso. Parando containers existentes...
)

REM Parar containers existentes
echo 🛑 Parando containers existentes...
docker-compose down

REM Perguntar sobre limpeza de imagens antigas
set /p cleanup="Deseja limpar imagens antigas? (y/N): "
if /i "%cleanup%"=="y" (
    echo 🧹 Limpando imagens antigas...
    docker system prune -f
    docker image prune -f
)

REM Build e start dos containers
echo 🔨 Fazendo build e iniciando containers...
docker-compose up --build -d

REM Aguardar containers iniciarem
echo ⏳ Aguardando containers iniciarem...
timeout /t 10 /nobreak >nul

REM Verificar se os containers estão rodando
echo 🔍 Verificando status dos containers...
docker-compose ps

REM Verificar health check
echo 🏥 Verificando saúde da aplicação...
timeout /t 30 /nobreak >nul
docker-compose exec app curl -f http://localhost:8080/ || echo "⚠️  Health check falhou - verificando logs..."

echo.
echo ✅ Deploy concluído!
echo 📱 Aplicação disponível em: http://localhost:8080
echo 🌐 Acesso externo em: http://%COMPUTERNAME%:8080
echo 📊 Para ver logs: docker-compose logs -f app
echo 🛑 Para parar: docker-compose down
echo 🔧 Para debug: docker-compose exec app sh
pause
