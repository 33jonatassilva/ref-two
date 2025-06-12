
FROM node:18-alpine

WORKDIR /app

# Instalar dependências do sistema necessárias incluindo curl para health check
RUN apk add --no-cache python3 make g++ git curl

# Copiar arquivos de dependências
COPY package*.json ./
COPY bun.lockb ./

# Instalar dependências
RUN npm ci --only=production

# Copiar código fonte
COPY . .

# Criar diretório de banco de dados com permissões corretas
RUN mkdir -p database && chmod 755 database

# Build da aplicação
RUN npm run build

# Expor porta
EXPOSE 8080

# Comando para iniciar a aplicação
CMD ["npm", "run", "preview", "--", "--host", "0.0.0.0", "--port", "8080"]
