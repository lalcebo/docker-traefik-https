# Traefik v2 HTTPS

Traefik v2 on localhost with HTTPS support using **local.dev** domain.

### Requirements

- [Docker](https://www.docker.com)
- [Docker Compose](https://docs.docker.com/compose/install)
- [MKCert](https://github.com/FiloSottile/mkcert)

### WARNING FOR MICROSOFT WINDOWS!!!

```shell
# Require this environment var
SET COMPOSE_CONVERT_WINDOWS_PATHS=1
```

To get started:

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

# Create networks that will be used by Træfik:
docker network create devel

# Create .env file that will be use by scripts.
# NOTE: Remember edit for enable the apps & servers you want.
cp .env.dist .env
```

### Host File

Use [add_hosts.sh](add_hosts.sh) script for automatically add the virtual hosts to your windows or linux hosts file. Required admin privileges.

Now, start containers with:

```shell
# Start Træfik Project
./start.sh
```

You can now go to your browser at [proxy.local.dev](https://proxy.local.dev) for Træfik dashboard, enjoy 🚀!
