# CI setup for Readium LCP

This folder contains the CI setup for Readium LCP. It contains Dockerfiles for each server component and a Helm chart for easy kubernetes deployment.

## Dockerfiles
Simple Dockerfile which contains all executables and a localhost config for testing.

The only difference between LCP and LSD images is which executable is run.
They are defined in the same Dockerfile using the following stage targets:
* runtime-lcp
* runtime-lsd

## Build and run LCP & LSD servers
To test LCP server components locally, simply run this command:
```
docker compose up -d
```

## Placeholders

### config.localhost.yaml
Simple config for local testing. Assumes you will expose ports 8989-8990 on 127.0.0.1.

### htpasswd
Placeholder htpasswd is just `admin` as username and `Test1234` as password.

## Overriding with volumes

You should not run the default config in production. To change the config, simply use volume mounts to override the following files:
* `/app/config.yaml`
* `/app/htpasswd`
* `/app/certs`

Basically the config.yaml decides the location of all other files and which ports to use, so modify it wisely.
