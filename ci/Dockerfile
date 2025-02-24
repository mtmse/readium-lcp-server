###############
# Build image #
###############
FROM golang:1.22-bookworm AS builder

WORKDIR /lcp

COPY . /lcp/.

ENV GOPATH=/lcp/build

RUN apt-get update && apt-get -y install build-essential apache2-utils && apt-get clean

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

RUN mkdir -p /mnt/cache
RUN mkdir -p /data/files && chown -R 1001:1001 /data/files

# Set timezone and locale to Swedish (Sweden)
ENV TZ="Europe/Stockholm"
ENV LANG="sv_SE.UTF-8"
ENV LC_ALL="sv_SE.UTF-8"

# Add non-root user
ARG UID=1001
ARG GID=1001
RUN groupadd --gid $GID app && \
	adduser --disabled-password --gid $GID --uid $UID lcp

RUN mkdir -p /data/db && \
    mkdir -p /data/files && chown -R $UID:$GID /data

# Update CA certificates
RUN apt-get update && apt-get -y install apache2-utils ca-certificates && apt-get clean

# Copy over all bins, CMD can be changed at runtime.
COPY --from=builder --chown=$UID:$GID /lcp/build/bin /app/bin

COPY test/cert/cert-edrlab-test.pem /app/cert/edrlab.crt
COPY test/cert/privkey-edrlab-test.pem /app/cert/edrlab.key
COPY test/.htpasswd /app/.htpasswd
COPY ci/config.yaml /app/config.yaml

COPY ci/entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]

# Run as non-root LCP user
USER lcp

# Mounted config.yaml decides which ports to use. This is the default from config.localhost.yml.
USER root

# Expose port for lcpserver
EXPOSE 8989

CMD ["/app/bin/lcpserver"]

#######################
# Runtime image (LSD) #
#######################
FROM runtime-lcp AS runtime-lsd
LABEL org.opencontainers.image.source https://github.com/notalib/readium-lcp-server

RUN chmod +x /app/entrypoint.sh
ENTRYPOINT ["/app/entrypoint.sh"]

EXPOSE 8990

CMD ["/app/bin/lsdserver"]
