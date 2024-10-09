# Byggsteg för Angular frontend
FROM node:8-alpine AS builder

WORKDIR /app

# Sätt NODE_ENV till development för att installera devDependencies
ENV NODE_ENV=development

# Kopiera package.json från Angular frontend
COPY frontend/manage/package*.json ./

# Installera beroenden, inklusive devDependencies
RUN npm install

# Kopiera resten av Angular frontend-koden
COPY frontend/manage/ ./

# Bygg Angular-applikationen
RUN npm run build

# Serve-steg med Nginx
FROM nginx:alpine AS runtime-test-frontend

# Kopiera de byggda filerna från builder-stegen till Nginx:s dokumentrot
COPY --from=builder /app/dist /usr/share/nginx/html

# Exponera port 80
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
