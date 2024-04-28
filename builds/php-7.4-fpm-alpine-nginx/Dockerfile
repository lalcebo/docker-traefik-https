FROM php:7.4-fpm-alpine3.16

LABEL org.opencontainers.image.title="NGINX (PHP 7.4)"
LABEL org.opencontainers.image.description="This image contains NGINX with PHP 7.4 (xDebug, Composer) & NodeJS. Use only for development."
LABEL org.opencontainers.image.source="https://github.com/lalcebo/docker-traefik-https"
LABEL org.opencontainers.image.authors="Jorge P. Hernandez Lalcebo <lalcebo2003@gmail.com>"

ARG XDEBUG_VERSION=3.1.5
ARG IMAGICK_VERSION=3.7.0
ARG MONGODB_VERSION=1.18.1

RUN apk add --update --no-cache libzip libpng libjpeg-turbo \
    libwebp freetype icu libevent nginx supervisor libpq gmp \
    nodejs npm gawk git openssh libxml2 c-client imagemagick libgomp

RUN apk add --update --no-cache --virtual build-essentials \
    icu-dev icu-libs zlib-dev g++ make automake autoconf libzip-dev libpq-dev \
    libpng-dev libwebp-dev libjpeg-turbo-dev freetype-dev libevent-dev pcre-dev \
    openssl-dev linux-headers libxml2-dev imap-dev imagemagick-dev libtool gmp-dev \
    && docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install intl \
    && docker-php-ext-install opcache \
    && docker-php-ext-install pgsql \
    && docker-php-ext-install pdo_pgsql \
    && docker-php-ext-install exif \
    && docker-php-ext-install gmp \
    && docker-php-ext-install zip \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install imap \
    && docker-php-ext-install pcntl \
    && docker-php-ext-install sockets \
    && docker-php-ext-install soap

RUN pecl install redis igbinary \
    imagick-${IMAGICK_VERSION} \
    xdebug-${XDEBUG_VERSION} \
    mongodb-${MONGODB_VERSION}

RUN docker-php-ext-enable redis \
    && docker-php-ext-enable igbinary \
    && docker-php-ext-enable xdebug \
    && docker-php-ext-enable imagick \
    && docker-php-ext-enable mongodb \
    && docker-php-source delete

RUN apk del build-essentials \
    && rm -f /usr/src/php* \
    && rm -rf /tmp/pear \
    && rm -rf /var/www/*

# php environment
ENV PHP_MAX_EXECUTION_TIME=${PHP_MAX_EXECUTION_TIME:-30}
ENV PHP_ERROR_REPORTING=${PHP_ERROR_REPORTING:-E_ALL}
ENV PHP_DISPLAY_ERRORS=${PHP_DISPLAY_ERRORS:-On}
ENV PHP_DISPLAY_STARTUP_ERRORS=${PHP_DISPLAY_STARTUP_ERRORS:-On}
ENV PHP_LOG_ERRORS=${PHP_LOG_ERRORS:-On}
ENV PHP_MEMORY_LIMIT=${PHP_MEMORY_LIMIT:-128M}
ENV PHP_DATE_TIMEZONE=${PHP_DATE_TIMEZONE:-UTC}
ENV PHP_POST_MAX_SIZE=${PHP_POST_MAX_SIZE:-8M}
ENV PHP_UPLOAD_MAX_FILESIZE=${PHP_UPLOAD_MAX_FILESIZE:-2M}
ENV PHP_MAX_FILE_UPLOADS=${PHP_MAX_FILE_UPLOADS:-20}
ENV PHP_MAX_INPUT_VARS=${PHP_MAX_INPUT_VARS:-1000}
ENV PHP_SESSION_SAVE_PATH=${PHP_SESSION_SAVE_PATH:-/tmp}
ENV PHP_REALPATH_CACHE_SIZE=${PHP_REALPATH_CACHE_SIZE:-4096K}
ENV PHP_REALPATH_CACHE_TTL=${PHP_REALPATH_CACHE_TTL:-120}
ENV PHP_VARIABLES_ORDER=${PHP_VARIABLES_ORDER:-EGPCS}
ENV PHP_CURL_CA_INFO=${PHP_CURL_CA_INFO:-/tmp/cacert.pem}
ENV PHP_OPENSSL_CA_FILE=${PHP_OPENSSL_CA_FILE:-/tmp/cacert.pem}

# xdebug
ENV PHP_XDEBUG_IDEKEY=${PHP_XDEBUG_IDEKEY:-PHPSTORM}
ENV PHP_XDEBUG_CLIENT_HOST=${PHP_XDEBUG_CLIENT_HOST:-host.docker.internal}
ENV PHP_XDEBUG_CLIENT_PORT=${PHP_XDEBUG_CLIENT_PORT:-9003}
ENV PHP_XDEBUG_MODE=${PHP_XDEBUG_MODE:-develop,debug,profile}
ENV PHP_XDEBUG_START_WITH_REQUEST=${PHP_XDEBUG_START_WITH_REQUEST:-default}
ENV PHP_XDEBUG_CLIENT_DISCOVERY_HEADER=${PHP_XDEBUG_CLIENT_DISCOVERY_HEADER:-1}
ENV PHP_XDEBUG_OUTPUT_DIR=${PHP_XDEBUG_OUTPUT_DIR:-/tmp}
ENV PHP_XDEBUG_LOG_LEVEL=${PHP_XDEBUG_LOG_LEVEL:-1}

# install composer
ENV COMPOSER_HOME=${COMPOSER_HOME:-"/tmp/composer"}
ENV COMPOSER_CACHE_DIR=/dev/null
RUN php -r "echo file_get_contents('https://getcomposer.org/installer');" | \
    php -- --install-dir=/usr/local/bin --filename=composer

# npm
ENV NPM_HOME=${NPM_HOME:-"/tmp/npm"}

# php
RUN rm -fr \
    /usr/local/etc/php-fpm.* \
    /usr/local/etc/php-fpm.d/* \
    /usr/local/etc/php/conf.d/*
COPY shared/config/usr/local/etc/php/ /usr/local/etc/php/
COPY shared/config/usr/local/etc/php-fpm.conf /usr/local/etc/
COPY shared/config/usr/local/etc/php-fpm.d/ /usr/local/etc/php-fpm.d/

RUN rm -f \
    /usr/local/etc/php/conf.d/20-docker-php-ext-swoole.ini \
    /usr/local/etc/php/conf.d/99-docker-php-ext-ev.ini \
    /usr/local/etc/php/conf.d/99-docker-php-ext-event.ini

# supervisor
COPY shared/config/etc/supervisor/supervisord.conf /etc/supervisord.conf
COPY shared/config/etc/supervisor/supervisor.d/* /etc/supervisor.d/

# nginx
COPY shared/config/etc/nginx/nginx.conf /etc/nginx/nginx.conf
COPY shared/config/etc/nginx/http.d/* /etc/nginx/http.d/

# ssh
COPY shared/config/etc/ssh/ssh_config /etc/ssh/ssh_config

EXPOSE 80

ENV WORKDIR=${WORKDIR:-"/var/www/html"}
ENV HANDLER=${HANDLER:-"public"}
ENV PATH=$WORKDIR:$WORKDIR/vendor/bin:$WORKDIR/node_modules/.bin:$PATH

WORKDIR $WORKDIR

# www
RUN mkdir -p "$WORKDIR/$HANDLER"
RUN { \
  echo "<?php"; \
  echo "declare(strict_types=1);"; \
  echo "phpinfo();"; \
} > "$WORKDIR/$HANDLER/index.php"

# scripts
ADD shared/scripts/docker-entrypoint.sh /
ADD shared/scripts/docker-functions.sh /usr/local/bin/
ADD shared/scripts/docker-service.sh /usr/local/bin/
ADD shared/scripts/docker-composer.sh /usr/local/bin/
ADD shared/scripts/docker-github.sh /usr/local/bin/
ADD shared/scripts/docker-nodejs.sh /usr/local/bin/
RUN chmod +x /*.sh /usr/local/bin/*.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
