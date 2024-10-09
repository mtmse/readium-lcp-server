# Byggsteg för Angular frontend
FROM node:12-alpine AS builder

WORKDIR /app

# Installera Git
RUN apk add --no-cache git

# Byt ut git:// med https:// för alla Git-repositorier
RUN git config --global url."https://".insteadOf git://

# Kopiera package.json och package-lock.json från Angular frontend
COPY frontend/manage/package*.json ./

# Installera beroenden, inklusive devDependencies
RUN npm install --no-audit --no-fund

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
