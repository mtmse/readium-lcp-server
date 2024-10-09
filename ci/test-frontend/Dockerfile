# Byggsteg för Go frontend
FROM golang:1.20-alpine AS builder

WORKDIR /app

# Kopiera Go-moduler och ladda ner beroenden
COPY frontend/go.mod frontend/go.sum ./
RUN go mod download

# Kopiera resten av frontend-koden
COPY frontend/ ./

# Bygg frontend-applikationen
RUN go build -o frontend-app

# Serve-steg med Nginx
FROM nginx:alpine

# Kopiera den byggda frontend-applikationen till Nginx:s dokumentrot
COPY --from=builder /app/frontend-app /usr/share/nginx/html/

# Exponera port 80
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
