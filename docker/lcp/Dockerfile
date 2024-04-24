# Build image
FROM --platform=$BUILDPLATFORM golang:1.22-alpine as lcpserver-builder

WORKDIR /lcp

COPY . /lcp/.

ENV GOPATH=/lcp/build

RUN apk add build-base

ENV CGO_CFLAGS="-D_LARGEFILE64_SOURCE"

RUN CGO_ENABLED=1 go build -o $GOPATH/bin/ ./lcpserver
RUN go build -o $GOPATH/bin/ ./lsdserver
RUN go build -o $GOPATH/bin/ ./lcpencrypt

# Runtime image
FROM alpine:latest
LABEL org.opencontainers.image.source https://github.com/notalib/readium-lcp-server
WORKDIR /app

ENV GOPATH=/app

RUN mkdir -p /data/db && \
    mkdir -p /data/files && \
    mkdir -p /app/cert

# Copy over all bins, CMD can be changed at runtime.
COPY --from=lcpserver-builder /lcp/build/bin /app

# Mounted config.yaml decides which ports to use. These are just defaults.
EXPOSE 8989-8990

CMD ["/app/lcpserver"]
