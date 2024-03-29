# Traefik v2 HTTPS

[![Software License][ico-license]][link-license]

## Introduction

Traefik v2 on localhost with HTTPS support using **local.dev** domain. This project creates different server app
containers to use for your projects on local like MySQL, MariaDB, Redis, Memcached or another.

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

# Copy require config files
cp config/traefik/config.yml.dist config/traefik/config.yml
cp config/dnsmasq/dnsmasq.d/dnsmasq.conf.dist config/dnsmasq/dnsmasq.d/dnsmasq.conf

# Generate certificate for domain 'local.dev', and their sub-domains '*.local.dev'
# NOTE: You can generate as many certificates for domains as you want, remember to
#       edit the config.yml file and add config section for them.
mkcert \
  -cert-file config/traefik/certs/local.dev.crt \
  -key-file config/traefik/certs/local.dev.key \
  'local.dev' '*.local.dev'

# Create network that will be used
docker network create docker-traefik-https

# Create .env file that will be use by scripts.
# NOTE: Remember edit for enable the services you want.
cp .env.dist .env

# Now, start containers
./start.sh
```

## Hooks

All hooks are stored in the hooks subdirectory.

* The `pre-<service>` hook is run before start the container.
* The `post-<service>` hook is run after start the container.
* The `stop-<service>` hook is run after stop the container.

Example `hooks/pre-dynamodb` hook:
```shell
#!/usr/bin/env sh

# the folder for the db file must be writable by all
DATA_PATH=.data/dynamodb

if [ ! -d $DATA_PATH ]; then
    mkdir -p $DATA_PATH && chmod -R 777 $DATA_PATH
fi
```

## Hosts & Dashboard

```shell
# dnsmasq server test
dig @127.0.0.1 +noall +answer +stats whatever.local.dev
```

* Set your nameserver to `127.0.0.1`, the dnsmasq server will resolve `*.local.dev` automatic, for any external domains it will use Cloudflare nameserver.
* You can now go to your browser at [proxy.local.dev](https://proxy.local.dev) for Træfik dashboard, enjoy 🚀!

## Postman

Enable CA Certificates setting and add "rootCA.pem" file. To know it location run ```mkcert --CAROOT```

![CA Certificates](docs/postman_settings_cert.png)

## Build Images

### Requirements

- [Buildx](https://docs.docker.com/build/install-buildx/)

```shell
# If it's the first build, run
docker run --privileged --rm tonistiigi/binfmt --install all
docker buildx create --name multiarch --driver docker-container --use

# Now, build images
./builds/make-images.sh
```

## About

I'll try to maintain this project as simple as possible, but Pull Requests are welcomed!

## License

The MIT License (MIT). Please see [License File][link-license] for more information.

[ico-license]: https://img.shields.io/badge/license-MIT-brightgreen.svg?style=for-the-badge&color=blue

[link-license]: LICENSE
