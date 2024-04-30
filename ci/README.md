# CI for Readium LCP

This folder contains the CI setup for Readium LCP. It contains Dockerfiles for each server component and a Helm chart for easy kubernetes deployment.

## Dockerfile
A Dockerfile which contains all executables and a localhost config for testing.

The only difference between LCP and LSD images is which executable is run.
They are defined in the same Dockerfile using the following stage targets:
* runtime-lcp
* runtime-lsd

### Build and run LCP & LSD servers
To test LCP server components locally, simply run this command:
```
docker compose up -d
```

### Placeholders

#### config.localhost.yaml
Simple config for local testing. Assumes you will expose ports 8989-8990 on localhost.

#### htpasswd
Placeholder htpasswd is just `admin` as username and `Test1234` as password.

### Overriding with volumes

You should not run the default config in production. To change the config, simply use volume mounts to override the following files:
* `/app/config.yaml`
* `/app/htpasswd`
* `/app/certs`

Basically the config.yaml decides the location of all other files and which ports to use, so modify it wisely.

## Helm chart for Kubernetes
We've included a rather simple Helm chart for installing LCP to a Kubernetes cluster at `./ci/helm-chart`

To install this chart simply run the following command:

`helm upgrade --install ./ci/helm-chart --set lcp.public_base_url=https://lcp.domain.com --set lsd.public_base_url=https://lsd.domain.com --set auth.username=admin --set auth.password=your-password`

For easier setup of all values for your domain, copy `values.yaml` to a `my-values.yaml`, modify it as needed and run this command:

`helm upgrade --install ./ci/helm-chart -f path/to/your/my-values.yaml`
