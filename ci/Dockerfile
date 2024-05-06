###############
# Build image #
###############
FROM --platform=$BUILDPLATFORM golang:1.22-alpine as builder

WORKDIR /lcp

COPY . /lcp/.

ENV GOPATH=/lcp/build

RUN apk add build-base

# Needed for sqlite3 lib
ENV CGO_CFLAGS="-D_LARGEFILE64_SOURCE"

RUN CGO_ENABLED=1 go build -o $GOPATH/bin/ ./lcpserver
RUN go build -o $GOPATH/bin/ ./lsdserver
RUN go build -o $GOPATH/bin/ ./lcpencrypt

#######################
# Runtime image (LCP) #
#######################
FROM alpine:latest as runtime-lcp
LABEL org.opencontainers.image.source https://github.com/notalib/readium-lcp-server
WORKDIR /app

# Add non-root user
ARG UID=1001
ARG GID=1001
RUN addgroup --gid $GID app && \
    adduser --disabled-password -G app --uid $UID lcp

RUN mkdir -p /data/db && \
    mkdir -p /data/files && chown -R $UID:$GID /data

# Copy over all bins, CMD can be changed at runtime.
COPY --from=builder --chown=$UID:$GID /lcp/build/bin /app

# Copy in default localhost config and certs (override with volume-mapping at runtime).
COPY test/cert/cert-edrlab-test.pem /app/cert/edrlab.crt
COPY test/cert/privkey-edrlab-test.pem /app/cert/edrlab.key
COPY test/config.localhost.yaml /app/config.yaml
COPY test/.htpasswd /app/.htpasswd

# Run as non-root LCP user
USER lcp

# Mounted config.yaml decides which ports to use. This is the default from config.localhost.yml.
EXPOSE 8989

CMD ["/app/lcpserver"]

#######################
# Runtime image (LSD) #
#######################
FROM runtime-lcp as runtime-lsd
LABEL org.opencontainers.image.source https://github.com/notalib/readium-lcp-server

# Mounted config.yaml decides which ports to use. This is the default from config.localhost.yml.
EXPOSE 8990

CMD ["/app/lsdserver"]
