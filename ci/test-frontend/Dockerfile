# Byggsteg
FROM node:16-alpine AS builder

WORKDIR /app

# Kopiera package.json och package-lock.json för att installera beroenden
COPY ../../frontend/package*.json ./

# Installera beroenden
RUN npm install

# Kopiera resten av koden
COPY ../../frontend/ .

# Bygg frontend
RUN npm run build

# Serve-steg
FROM nginx:alpine AS runtime-test-frontend

# Kopiera byggda filer till Nginx:s dokumentrot
COPY --from=builder /app/build /usr/share/nginx/html

# Kopiera Nginx-konfiguration för Test Frontend (valfritt, om du behöver anpassa Nginx)
# COPY nginx-test-frontend.conf /etc/nginx/conf.d/default.conf

# Exponera port 80
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
