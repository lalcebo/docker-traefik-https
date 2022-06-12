FROM ghcr.io/lalcebo/docker-traefik-https/opensuse-base:latest

LABEL maintainer="Jorge P. Hernandez Lalcebo <lalcebo2003@gmail.com>"
LABEL org.opencontainers.image.source="https://github.com/lalcebo/docker-traefik-https"
LABEL org.opencontainers.image.description="This image contains openSUSE Leap Apache with PHP 7.4, Composer & NodeJS. Use only for development."

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
ENV PHP_XDEBUG_DEFAULT_ENABLE=${PHP_XDEBUG_DEFAULT_ENABLE:-1}
ENV PHP_XDEBUG_REMOTE_ENABLE=${PHP_XDEBUG_REMOTE_ENABLE:-1}
ENV PHP_XDEBUG_REMOTE_HOST=${PHP_XDEBUG_REMOTE_HOST:-host.docker.internal}
ENV PHP_XDEBUG_REMOTE_PORT=${PHP_XDEBUG_REMOTE_PORT:-9000}
ENV PHP_XDEBUG_REMOTE_AUTO_START=${PHP_XDEBUG_REMOTE_AUTO_START:-0}
ENV PHP_XDEBUG_REMOTE_CONNECT_BACK=${PHP_XDEBUG_REMOTE_CONNECT_BACK:-0}
ENV PHP_XDEBUG_REMOTE_LOG=${PHP_XDEBUG_REMOTE_LOG:-/tmp/xdebug.log}
ENV PHP_XDEBUG_PROFILER_ENABLE=${PHP_XDEBUG_PROFILER_ENABLE:-1}
ENV PHP_XDEBUG_PROFILER_OUTPUT_DIR=${PHP_XDEBUG_PROFILER_OUTPUT_DIR:-/tmp}
ENV PHP_XDEBUG_TRACE_ENABLE=${PHP_XDEBUG_TRACE_ENABLE:-1}
ENV PHP_XDEBUG_TRACE_OUTPUT_DIR=${PHP_XDEBUG_TRACE_OUTPUT_DIR:-/tmp}

RUN zypper --non-interactive refresh \
    # Update and install packages
    && zypper up -y && zypper --non-interactive install \
        # Apache2
        apache2 apache2-mod_php7 \
        # PHP
        php7-bcmath php7-bz2 php7-calendar php7-ctype php7-curl \
        php7-dba php7-enchant php7-exif php7-ftp php7-tidy php7-dom \
        php7-fileinfo php7-gd php7-gettext php7-iconv php7-redis \
        php7-intl php7-json php7-mbstring php7-mysql php7-xmlrpc \
        php7-opcache php7-openssl php7-pcntl php7-pdo php7-pgsql \
        php7-phar php7-posix php7-soap php7-sockets php7-sodium \
        php7-sqlite php7-tokenizer php7-xdebug php7-xmlreader \
        php7-xmlwriter php7-xsl php7-zip php7-zlib php7-xdebug \
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
RUN ["a2enmod", "php7"]
ADD .shared/config/etc/apache2/*.conf /etc/apache2/
ADD .shared/config/etc/apache2/conf.d/php7.conf /etc/apache2/conf.d/php7.conf

# PHP
RUN chmod 644 /usr/lib64/php7/extensions/*.so

ADD .shared/config/etc/php7/conf.d/* /etc/php7/conf.d/
ADD .shared/config/etc/php7/php.ini /etc/php7/apache2/
ADD .shared/config/etc/php7/php.ini /etc/php7/cli/

RUN rm -rf /srv/www/cgi-bin
RUN mv /srv/www/htdocs /srv/www/public
RUN echo "<?php phpinfo(); ?>" > /srv/www/public/index.php

# Ports
EXPOSE 80
WORKDIR /srv/www

# Start
ADD php-7.4-apache2/docker-entrypoint.sh /usr/sbin/docker-entrypoint.sh
ADD .shared/scripts/github.sh /usr/sbin/github.sh
ADD .shared/scripts/composer.sh /usr/sbin/composer.sh

RUN chmod +x /usr/sbin/docker-entrypoint.sh
RUN chmod +x /usr/sbin/github.sh
RUN chmod +x /usr/sbin/composer.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
