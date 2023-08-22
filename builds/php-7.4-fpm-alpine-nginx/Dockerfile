FROM php:7.4-fpm-alpine3.16

LABEL authors="Jorge P. Hernandez Lalcebo <lalcebo2003@gmail.com>"
LABEL comment="This image contains NGINX with PHP 7.4 (xDebug, Composer) & NodeJS. Use only for development."

ARG XDEBUG_VERSION=3.1.4

RUN apk add --no-cache libzip libpng libjpeg-turbo \
    libwebp freetype icu libevent nginx supervisor \
    nodejs npm gawk git openssh libxml2

RUN apk add --no-cache --virtual build-essentials \
    icu-dev icu-libs zlib-dev g++ make automake autoconf libzip-dev \
    libpng-dev libwebp-dev libjpeg-turbo-dev freetype-dev libevent-dev \
    openssl-dev linux-headers libxml2-dev \
    && docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install intl \
    && docker-php-ext-install opcache \
    && docker-php-ext-install exif \
    && docker-php-ext-install zip \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install pcntl \
    && docker-php-ext-install sockets \
    && docker-php-ext-install soap

RUN pecl install redis igbinary xdebug-${XDEBUG_VERSION}
RUN docker-php-ext-enable redis \
    && docker-php-ext-enable igbinary \
    && docker-php-ext-enable xdebug \
    && docker-php-source delete

RUN apk del build-essentials \
    && rm -f /usr/src/php* \
    && rm -rf /tmp/pear

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
ENV PHP_CURL_CA_INFO=${PHP_CURL_CA_INFO:-}
ENV PHP_OPENSSL_CA_FILE=${PHP_OPENSSL_CA_FILE:-}

# xdebug
ENV PHP_XDEBUG_IDEKEY=${PHP_XDEBUG_IDEKEY:-PHPSTORM}
ENV PHP_XDEBUG_CLIENT_HOST=${PHP_XDEBUG_CLIENT_HOST:-host.docker.internal}
ENV PHP_XDEBUG_CLIENT_PORT=${PHP_XDEBUG_CLIENT_PORT:-9003}
ENV PHP_XDEBUG_MODE=${PHP_XDEBUG_MODE:-develop,debug,profile}
ENV PHP_XDEBUG_START_WITH_REQUEST=${PHP_XDEBUG_START_WITH_REQUEST:-default}
ENV PHP_XDEBUG_CLIENT_DISCOVERY_HEADER=${PHP_XDEBUG_CLIENT_DISCOVERY_HEADER:-1}
ENV PHP_XDEBUG_OUTPUT_DIR=${PHP_XDEBUG_OUTPUT_DIR:-/tmp}

# install composer
ENV COMPOSER_HOME=${COMPOSER_HOME:-"/tmp/composer"}
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN php -r "echo file_get_contents('https://getcomposer.org/installer');" | \
    php -- --install-dir=/usr/local/bin --filename=composer

# npm
ENV NPM_HOME=${NPM_HOME:-"/tmp/npm"}

# php
RUN rm -fr \
    /usr/local/etc/php-fpm.* \
    /usr/local/etc/php-fpm.d/* \
    /usr/local/etc/php/* \
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
ENV WORKDIR=${WORKDIR:-"/var/www/app"}
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
ADD shared/scripts/commons.sh /usr/local/bin/
ADD shared/scripts/docker.sh /usr/local/bin/
ADD shared/scripts/composer.sh /usr/local/bin/
ADD shared/scripts/github.sh /usr/local/bin/
ADD shared/scripts/npm.sh /usr/local/bin/
RUN chmod +x /*.sh /usr/local/bin/*.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
