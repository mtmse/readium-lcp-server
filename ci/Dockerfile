###############
# Build image #
###############
FROM golang:1.22-bookworm AS builder

WORKDIR /lcp

COPY . /lcp/.

ENV GOPATH=/lcp/build

RUN apt-get update && apt-get -y install build-essential && apt-get clean

# Needed for sqlite3 lib
ENV CGO_CFLAGS="-D_LARGEFILE64_SOURCE"
ENV CGO_ENABLED=1

# Must be defined as ARG first to use. Inspiration from https://www.docker.com/blog/faster-multi-platform-builds-dockerfile-cross-compilation-guide/
ARG TARGETOS TARGETARCH
ENV GOOS=${TARGETOS}
ENV GOARCH=${TARGETARCH}

RUN go build -o $GOPATH/bin/ ./lcpserver
RUN go build -o $GOPATH/bin/ ./lsdserver
RUN go build -o $GOPATH/bin/ ./lcpencrypt

#######################
# Runtime image (LCP) #
#######################
FROM debian:bookworm-slim AS runtime-lcp
LABEL org.opencontainers.image.source https://github.com/notalib/readium-lcp-server
WORKDIR /app

# Add non-root user
ARG UID=1001
ARG GID=1001
RUN groupadd --gid $GID app && \
    adduser --disabled-password -gid $GID --uid $UID lcp

RUN mkdir -p /data/db && \
    mkdir -p /data/files && chown -R $UID:$GID /data

# Copy over all bins, CMD can be changed at runtime.
COPY --from=builder --chown=$UID:$GID /lcp/build/bin /app

# Copy in default localhost config and certs (override with volume-mapping at runtime).
COPY test/cert/cert-edrlab-test.pem /app/cert/edrlab.crt
COPY test/cert/privkey-edrlab-test.pem /app/cert/edrlab.key
COPY test/config.localhost.yaml /app/config.yaml
COPY test/.htpasswd /app/.htpasswd

# RUN ls -al /app && sleep 600

# Run as non-root LCP user
USER lcp

# Mounted config.yaml decides which ports to use. This is the default from config.localhost.yml.
EXPOSE 8989

CMD ["/app/lcpserver"]

#######################
# Runtime image (LSD) #
#######################
FROM runtime-lcp AS runtime-lsd
LABEL org.opencontainers.image.source https://github.com/notalib/readium-lcp-server

# Mounted config.yaml decides which ports to use. This is the default from config.localhost.yml.
EXPOSE 8990

CMD ["/app/lsdserver"]
