FROM ghcr.io/lalcebo/docker-traefik-https/base:latest as builder
WORKDIR /builder

ARG PHP_81_REPOSITORY=https://download.opensuse.org/repositories/devel:/languages:/php/openSUSE_Leap_15.4/devel:languages:php.repo
ARG XDEBUG_VERSION=3.2.0
ARG SWOOLE_VERSION=4.8.13
ARG PHPREDIS_VERSION=5.3.7
ARG IGBINARY_VERSION=3.2.14

# comunity repo for php 8.1
RUN zypper --non-interactive ar -G ${PHP_81_REPOSITORY}
RUN zypper up -y \
    # install packages
    && zypper -q --non-interactive install \
        php8-devel \
        file \
        re2c \
        curl \
        unzip \
        libssh2-devel \
        libbrotli-devel \
        c-ares-devel \
        libcurl-devel \
        libzstd-devel \
        make \
        gcc \
        autoconf \
    # clean up the zypper cache and logs
    && rm -rf /var/cache/zypp /var/log/zypp /var/log/zypper.log

RUN curl -LO https://github.com/xdebug/xdebug/archive/${XDEBUG_VERSION}.zip \
    && unzip ${XDEBUG_VERSION}.zip \
    && rm -f ${XDEBUG_VERSION}.zip \
    && cd xdebug-${XDEBUG_VERSION} \
    && phpize \
    && ./configure --enable-xdebug \
    && make \
    && cd /builder

RUN curl -LO https://github.com/swoole/swoole-src/archive/v${SWOOLE_VERSION}.zip \
    && unzip v${SWOOLE_VERSION}.zip \
    && rm -f v${SWOOLE_VERSION}.zip \
    && cd swoole-src-${SWOOLE_VERSION} \
    && phpize \
    && ./configure --enable-swoole \
      --enable-openssl --enable-http2 --enable-brotli \
      --enable-sockets --enable-mysqlnd --enable-cares \
      --enable-swoole-curl --enable-swoole-json \
    && make \
    && cd /builder

RUN curl -LO https://github.com/igbinary/igbinary/archive/${IGBINARY_VERSION}.zip \
    && unzip ${IGBINARY_VERSION}.zip \
    && rm -f ${IGBINARY_VERSION}.zip \
    && cd igbinary-${IGBINARY_VERSION} \
    && phpize \
    && ./configure CFLAGS="-O2 -g" --enable-igbinary \
    && make \
    && make install \
    && cd /builder

RUN curl -LO https://github.com/phpredis/phpredis/archive/${PHPREDIS_VERSION}.zip \
    && unzip ${PHPREDIS_VERSION}.zip \
    && rm -f ${PHPREDIS_VERSION}.zip \
    && cd phpredis-${PHPREDIS_VERSION} \
    && phpize \
    && ./configure --enable-redis \
      --enable-redis-igbinary --enable-redis-zstd \
    && make \
    && cd /builder

# final image
FROM ghcr.io/lalcebo/docker-traefik-https/base:latest

LABEL maintainer="Jorge P. Hernandez Lalcebo <lalcebo2003@gmail.com>"
LABEL org.opencontainers.image.source="https://github.com/lalcebo/docker-traefik-https"
LABEL org.opencontainers.image.description="This image contains openSUSE Leap with PHP 8.1 CLI, Composer & NodeJS. Use only for development."

# args
ARG PHP_81_REPOSITORY=https://download.opensuse.org/repositories/devel:/languages:/php/openSUSE_Leap_15.4/devel:languages:php.repo
ARG XDEBUG_VERSION=3.2.0
ARG SWOOLE_VERSION=4.8.13
ARG PHPREDIS_VERSION=5.3.7
ARG IGBINARY_VERSION=3.2.14

# env
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
ENV PHP_REALPATH_CACHE_TTL=${PHP_REALPATH_CACHE_TTL:-600}
ENV PHP_VARIABLES_ORDER=${PHP_VARIABLES_ORDER:-EGPCS}

ENV PHP_XDEBUG_IDEKEY=${PHP_XDEBUG_IDEKEY:-PHPSTORM}
ENV PHP_XDEBUG_CLIENT_HOST=${PHP_XDEBUG_CLIENT_HOST:-host.docker.internal}
ENV PHP_XDEBUG_CLIENT_PORT=${PHP_XDEBUG_CLIENT_PORT:-9003}
ENV PHP_XDEBUG_MODE=${PHP_XDEBUG_MODE:-develop,debug,profile}
ENV PHP_XDEBUG_START_WITH_REQUEST=${PHP_XDEBUG_START_WITH_REQUEST:-default}
ENV PHP_XDEBUG_CLIENT_DISCOVERY_HEADER=${PHP_XDEBUG_CLIENT_DISCOVERY_HEADER:-1}
ENV PHP_XDEBUG_OUTPUT_DIR=${PHP_XDEBUG_OUTPUT_DIR:-/tmp}

# comunity repo for php 8.1
RUN zypper --non-interactive ar -G ${PHP_81_REPOSITORY}
RUN zypper --non-interactive refresh

# update and install packages
RUN zypper up -y && zypper --non-interactive install \
    libcares2 libopenssl3 libbrotlidec1 libbrotlienc1 \
    # php
    php8-cli php8-bcmath php8-bz2 php8-calendar php8-ctype php8-curl \
    php8-dba php8-enchant php8-exif php8-ftp php8-tidy php8-dom \
    php8-fileinfo php8-gd php8-gettext php8-iconv php8-intl \
    php8-mbstring php8-mysql php8-opcache php8-openssl php8-pcntl \
    php8-pdo php8-pgsql php8-phar php8-posix php8-soap php8-zlib \
    php8-sockets php8-sodium php8-sqlite php8-tokenizer php8-xmlreader \
    php8-xmlwriter php8-xsl php8-zip php8-readline \
    # uninstall supervisor
    && pip3 uninstall -y supervisor \
    && rm -rf /etc/supervisor.d \
    # clean up the zypper cache and logs
    && rm -rf /var/cache/zypp /var/log/zypp /var/log/zypper.log

# composer
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN php -r "echo file_get_contents('https://getcomposer.org/installer');" | \
    php -- --install-dir=/usr/local/bin --filename=composer

# extensions
COPY --from=builder \
    /builder/xdebug-${XDEBUG_VERSION}/modules/xdebug.so \
    /usr/lib64/php8/extensions/xdebug.so
COPY --from=builder \
    /builder/swoole-src-${SWOOLE_VERSION}/modules/swoole.so \
    /usr/lib64/php8/extensions/swoole.so
COPY --from=builder \
    /builder/igbinary-${IGBINARY_VERSION}/modules/igbinary.so \
    /usr/lib64/php8/extensions/igbinary.so
COPY --from=builder \
    /builder/phpredis-${PHPREDIS_VERSION}/modules/redis.so \
    /usr/lib64/php8/extensions/redis.so

RUN chmod 644 /usr/lib64/php8/extensions/*.so

# php
ADD .shared/config/etc/php8/conf.d/* /etc/php8/conf.d/
ADD .shared/config/etc/php8/php.ini /etc/php8/cli/

# start
ADD php-8.1-cli/docker-entrypoint.sh /docker-entrypoint.sh
ADD .shared/scripts/composer.sh /composer.sh

RUN chmod +x /docker-entrypoint.sh
RUN chmod +x /composer.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["php", "-a"]
