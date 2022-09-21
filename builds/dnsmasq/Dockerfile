FROM alpine:latest

LABEL maintainer="Jorge P. Hernandez Lalcebo <lalcebo2003@gmail.com>"
LABEL org.opencontainers.image.source="https://github.com/lalcebo/docker-traefik-https"
LABEL org.opencontainers.image.description="This image contains Alpine DNSMasq server. Use only for development."

# update and install
RUN apk upgrade --no-cache
RUN apk add --no-cache --virtual=run-deps bash bind-tools dnsmasq

# clean
RUN rm -rf /tmp/* /var/cache/apk/* /var/tmp/*

# configs
ADD .shared/config/etc/dnsmasq/dnsmasq.conf /etc/dnsmasq.conf

# expose
EXPOSE 53/tcp
EXPOSE 53/udp

# start
ADD dnsmasq/docker-entrypoint.sh /docker-entrypoint.sh
ADD .shared/scripts/functions.sh /functions.sh

RUN chmod +x /docker-entrypoint.sh
RUN chmod +x /functions.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["dnsmasq", "-q", "-k", "--user=dnsmasq"]
