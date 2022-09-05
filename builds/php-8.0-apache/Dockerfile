FROM ghcr.io/lalcebo/docker-traefik-https/php-8.0-cli:latest

LABEL maintainer="Jorge P. Hernandez Lalcebo <lalcebo2003@gmail.com>"
LABEL org.opencontainers.image.source="https://github.com/lalcebo/docker-traefik-https"
LABEL org.opencontainers.image.description="This image contains openSUSE Leap Apache with PHP 8.0, Composer & NodeJS. Use only for development."

RUN zypper --non-interactive refresh \
    # update and install packages
    && zypper up -y && zypper --non-interactive install \
        # apache
        apache2 apache2-mod_php8 \
    # pip update and supervisor
    && pip3 install --upgrade pip \
    && pip3 install supervisor \
    # forward request and error logs to .docker log collector
    && ln -sf /dev/stdout /var/log/apache2/access_log \
    && ln -sf /dev/stderr /var/log/apache2/error_log \
    # clean up the zypper cache and logs
    && rm -rf /var/cache/zypp /var/log/zypp /var/log/zypper.log

# supervisor
RUN mkdir -p /etc/supervisor.d
ADD .shared/config/etc/supervisord.conf /etc/supervisord.conf
ADD .shared/config/etc/supervisor.d/apache2.conf /etc/supervisor.d/apache2.conf

# apache
RUN ["a2enmod", "-d", "userdir"]
RUN ["a2enmod", "rewrite"]
RUN ["a2enmod", "php8"]
ADD .shared/config/etc/apache2/*.conf /etc/apache2/
ADD .shared/config/etc/apache2/conf.d/php8.conf /etc/apache2/conf.d/php8.conf

# php
ADD .shared/config/etc/php8/php.ini /etc/php8/apache2/

RUN rm -rf /srv/www/cgi-bin
RUN mv /srv/www/htdocs /srv/www/public
RUN echo "<?php phpinfo(); ?>" > /srv/www/public/index.php

# ports
EXPOSE 80
WORKDIR /srv/www

# start
ADD php-8.0-apache/docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
