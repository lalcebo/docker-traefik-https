FROM ghcr.io/lalcebo/php:8.3-fpm-alpine-nginx

LABEL org.opencontainers.image.title="Reverb"
LABEL org.opencontainers.image.description="This image contains reverb server. Use only for development."
LABEL org.opencontainers.image.source="https://github.com/lalcebo/docker-traefik-https"
LABEL org.opencontainers.image.authors="Jorge P. Hernandez Lalcebo <lalcebo2003@gmail.com>"

# php
RUN rm -f \
    /usr/local/etc/php/conf.d/20-docker-php-ext-xdebug.ini

# supervisor
COPY shared/reverb/etc/supervisor/supervisor.d/* /etc/supervisor.d/

# nginx
COPY shared/reverb/etc/nginx/http.d/* /etc/nginx/http.d/

# reverb
RUN rm -rf $WORKDIR/*
RUN composer create-project laravel/laravel $WORKDIR
RUN composer require laravel/reverb:@beta
RUN rm -f $WORKDIR/.env* $WORKDIR/config/*
COPY shared/reverb/app/.env $WORKDIR/
COPY shared/reverb/app/reverb.php $WORKDIR/config
RUN artisan key:generate
RUN composer install --no-dev
RUN chown -R www-data:www-data $WORKDIR
