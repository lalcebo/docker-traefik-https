FROM ghcr.io/lalcebo/docker-traefik-https/opensuse-base:latest as builder
WORKDIR /builder

ARG XDEBUG_VERSION=3.1.5

RUN zypper up -y \
    # Install packages
    && zypper -q --non-interactive install \
        php8-devel \
        file \
        re2c \
        curl \
        unzip \
        libssh2-devel \
        make \
        gcc \
        autoconf \
    # clean up the zypper cache and logs.
    && rm -rf /var/cache/zypp /var/log/zypp /var/log/zypper.log

RUN mkdir xdebug \
    && cd xdebug \
    && curl -LO https://github.com/xdebug/xdebug/archive/${XDEBUG_VERSION}.zip \
    && unzip ${XDEBUG_VERSION}.zip \
    && cd xdebug-${XDEBUG_VERSION} \
    && phpize \
    && ./configure --enable-xdebug \
    && make

# Final image
FROM ghcr.io/lalcebo/docker-traefik-https/opensuse-base:latest

LABEL maintainer="Jorge P. Hernandez Lalcebo <lalcebo2003@gmail.com>"
LABEL org.opencontainers.image.source="https://github.com/lalcebo/docker-traefik-https"
LABEL org.opencontainers.image.description="This image contains openSUSE Leap Apache with PHP 8.0, Composer & NodeJS. Use only for development."

ARG XDEBUG_VERSION=3.1.5

# ENV vars
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
ENV PHP_XDEBUG_MODE=${PHP_XDEBUG_MODE:-off}
ENV PHP_XDEBUG_START_WITH_REQUEST=${PHP_XDEBUG_START_WITH_REQUEST:-no}
ENV PHP_XDEBUG_CLIENT_HOST=${PHP_XDEBUG_CLIENT_HOST:-host.docker.internal}
ENV PHP_XDEBUG_CLIENT_PORT=${PHP_XDEBUG_CLIENT_PORT:-9003}
ENV PHP_XDEBUG_CLIENT_DISCOVERY_HEADER=${PHP_XDEBUG_CLIENT_DISCOVERY_HEADER:-}
ENV PHP_XDEBUG_OUTPUT_DIR=${PHP_XDEBUG_OUTPUT_DIR:-/tmp}

RUN zypper --non-interactive refresh \
    # Update and install packages
    && zypper up -y && zypper --non-interactive install \
        # Apache2
        apache2 apache2-mod_php8 \
        # PHP
        php8-bcmath php8-bz2 php8-calendar php8-ctype php8-curl \
        php8-dba php8-enchant php8-exif php8-ftp php8-tidy php8-dom \
        php8-fileinfo php8-gd php8-gettext php8-iconv php8-intl \
        php8-mbstring php8-mysql php8-opcache php8-openssl php8-pcntl \
        php8-pdo php8-pgsql php8-phar php8-posix php8-soap php8-zlib \
        php8-sockets php8-sodium php8-sqlite php8-tokenizer php8-xmlreader \
        php8-xmlwriter php8-xsl php8-zip \
    # Forward request and error logs to .docker log collector
    && ln -sf /dev/stdout /var/log/apache2/access_log \
    && ln -sf /dev/stderr /var/log/apache2/error_log \
    # Clean up the zypper cache and logs.
    && rm -rf /var/cache/zypp /var/log/zypp /var/log/zypper.log

# PHP Composer
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN php -r "echo file_get_contents('https://getcomposer.org/installer');" | \
    php -- --install-dir=/usr/local/bin --filename=composer

# Supervisor
ADD .shared/config/etc/supervisor.d/apache2.conf /etc/supervisor.d/apache2.conf

# Apache2
RUN ["a2enmod", "-d", "userdir"]
RUN ["a2enmod", "rewrite"]
RUN ["a2enmod", "php8"]
ADD .shared/config/etc/apache2/*.conf /etc/apache2/
ADD .shared/config/etc/apache2/conf.d/php8.conf /etc/apache2/conf.d/php8.conf

# PHP
COPY --from=builder \
    /builder/xdebug/xdebug-${XDEBUG_VERSION}/modules/xdebug.so \
    /usr/lib64/php8/extensions/xdebug.so

RUN chmod 644 /usr/lib64/php8/extensions/*.so

ADD .shared/config/etc/php8/conf.d/* /etc/php8/conf.d/
ADD .shared/config/etc/php8/php.ini /etc/php8/apache2/
ADD .shared/config/etc/php8/php.ini /etc/php8/cli/

RUN rm -rf /srv/www/cgi-bin
RUN mv /srv/www/htdocs /srv/www/public
RUN echo "<?php phpinfo(); ?>" > /srv/www/public/index.php

# Ports
EXPOSE 80
WORKDIR /srv/www

# Start
ADD php-8.0-apache/docker-entrypoint.sh /usr/sbin/docker-entrypoint.sh
ADD .shared/scripts/github.sh /usr/sbin/github.sh
ADD .shared/scripts/composer.sh /usr/sbin/composer.sh

RUN chmod +x /usr/sbin/docker-entrypoint.sh
RUN chmod +x /usr/sbin/github.sh
RUN chmod +x /usr/sbin/composer.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
