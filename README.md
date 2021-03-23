# Traefik v2 HTTPS

[![Software License][ico-license]][link-license]

## Introduction

Traefik v2 on localhost with HTTPS support using **local.dev** domain. This project creates different server app
containers to use for your projects on local like MySQL (MariaDB), Redis, Memcached or anothers.

### Requirements

- [Docker](https://www.docker.com)
- [Docker Compose](https://docs.docker.com/compose/install)
- [MKCert](https://github.com/FiloSottile/mkcert)

### WARNING FOR MICROSOFT WINDOWS!!!

```shell
# Require this environment var
SET COMPOSE_CONVERT_WINDOWS_PATHS=1
```

## How to start

```shell
# Clone
git clone https://github.com/lalcebo/docker-traefik-https.git && cd docker-traefik-https

# If it's the first install of mkcert, run
mkcert -install

# Generate certificate for domain 'local.dev', '*.local.dev' and their sub-domains
mkcert \
  -cert-file config/traefik/certs/local.dev.crt \
  -key-file config/traefik/certs/local.dev.key \
  'local.dev' '*.local.dev'

# Create network that will be used
docker network create docker-traefik-https

# Create volume that will be used
docker volume create docker-traefik-https

# Create .env file that will be use by scripts.
# NOTE: Remember edit for enable the apps & servers you want.
cp .env.dist .env

# Now, start containers
./start.sh
```

## Hosts & Dashboard

* Use [add_hosts.sh](add_hosts.sh) script for automatically add the virtual hosts to your windows or linux hosts file.
  Required admin privileges.
* You can now go to your browser at [proxy.local.dev](https://proxy.local.dev) for Træfik dashboard, enjoy 🚀!

## About

I'll try to maintain this project as simple as possible, but Pull Requests are welcomed!

## License

The MIT License (MIT). Please see [License File][link-license] for more information.

[ico-license]: https://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat-square

[link-license]: LICENSE
