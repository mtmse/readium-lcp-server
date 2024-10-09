# Byggsteg för Angular frontend
FROM node:16-alpine AS builder

WORKDIR /app

# Kopiera package.json och package-lock.json från Angular frontend
COPY frontend/manage/package*.json ./

# Installera beroenden
RUN npm install

# Kopiera resten av Angular frontend-koden
COPY frontend/manage/ ./

# Bygg Angular-applikationen
RUN npm run build

# Serve-steg med Nginx
FROM nginx:alpine AS runtime-test-frontend

# Kopiera byggda filer från builder-stegen till Nginx:s dokumentrot
COPY --from=builder /app/dist /usr/share/nginx/html

# Kopiera anpassad Nginx-konfiguration om nödvändigt
# COPY ci/nginx/nginx-test-frontend.conf /etc/nginx/conf.d/default.conf

# Exponera port 80
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
