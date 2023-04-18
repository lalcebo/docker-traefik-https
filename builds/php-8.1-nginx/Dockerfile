FROM ghcr.io/lalcebo/docker-traefik-https/php-8.1-cli:latest

LABEL maintainer="Jorge P. Hernandez Lalcebo <lalcebo2003@gmail.com>"
LABEL org.opencontainers.image.source="https://github.com/lalcebo/docker-traefik-https"
LABEL org.opencontainers.image.description="This image contains openSUSE Leap Nginx with PHP 8.1, Composer & NodeJS. Use only for development."

RUN zypper --non-interactive refresh \
    # update and install packages
    && zypper up -y && zypper --non-interactive install \
        libcares2 libopenssl3 libbrotlidec1 libbrotlienc1 \
        # nginx
        nginx php8-fpm \
    # pip update and supervisor
    && pip3 install --upgrade pip \
    && pip3 install supervisor \
    # forward request and error logs to .docker log collector
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    # clean up the zypper cache and logs
    && rm -rf /var/cache/zypp /var/log/zypp /var/log/zypper.log

# supervisor
RUN mkdir -p /etc/supervisor.d
ADD .shared/config/etc/supervisord.conf /etc/supervisord.conf
ADD .shared/config/etc/supervisor.d/nginx.conf /etc/supervisor.d/nginx.conf
ADD .shared/config/etc/supervisor.d/php-fpm.conf /etc/supervisor.d/php-fpm.conf

# nginx
ADD .shared/config/etc/nginx/*.conf /etc/nginx/
ADD .shared/config/etc/nginx/vhosts.d/default.conf /etc/nginx/vhosts.d/default.conf

# php
ADD .shared/config/etc/php8/php.ini /etc/php8/fpm/
ADD .shared/config/etc/php8/fpm /etc/php8/fpm/

RUN rm -rf /srv/www/cgi-bin
RUN mv /srv/www/htdocs /srv/www/public
RUN echo "<?php phpinfo(); ?>" > /srv/www/public/index.php

# ports
EXPOSE 80
WORKDIR /srv/www

# start
ADD php-8.1-apache/docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
