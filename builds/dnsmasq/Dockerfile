FROM alpine:latest

LABEL org.opencontainers.image.title="DNSMasq"
LABEL org.opencontainers.image.source="https://github.com/lalcebo/docker-traefik-https"
LABEL org.opencontainers.image.description="This image contains Alpine DNSMasq server. Use only for development."
LABEL org.opencontainers.image.authors="Jorge P. Hernandez Lalcebo <lalcebo2003@gmail.com>"

# update and install
RUN apk upgrade --no-cache
RUN apk add --update --no-cache --virtual=run-deps bash bind-tools dnsmasq

# clean
RUN rm -rf /tmp/* /var/cache/apk/* /var/tmp/*

# configs
ADD shared/config/etc/dnsmasq/dnsmasq.conf /etc/dnsmasq.conf

# expose
EXPOSE 53/tcp
EXPOSE 53/udp

# start
ADD dnsmasq/docker-entrypoint.sh /docker-entrypoint.sh
ADD shared/scripts/docker-functions.sh /usr/local/bin/

RUN chmod +x /*.sh /usr/local/bin/*.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["dnsmasq", "-q", "-k", "--user=dnsmasq"]
