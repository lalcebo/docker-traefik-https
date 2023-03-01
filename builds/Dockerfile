FROM opensuse/leap:latest

LABEL maintainer="Jorge P. Hernandez Lalcebo <lalcebo2003@gmail.com>"
LABEL org.opencontainers.image.source="https://github.com/lalcebo/docker-traefik-https"

ARG NODEJS_VERSION=18

# env
ENV TZ=UTC

RUN zypper --non-interactive refresh \
    # update and install packages
    && zypper up -y && zypper --non-interactive install \
       # general
       python3-pip libssh2-1 unzip iputils iproute2 hostname \
       w3m nano git \
       # nodejs
       npm${NODEJS_VERSION} \
    # pip Update and supervisor
    && pip3 install --upgrade pip \
    && pip3 install supervisor \
    # clean up the zypper cache and logs
    && rm -rf /var/cache/zypp /var/log/zypp /var/log/zypper.log

# update .bashrc
RUN { \
    echo "alias ls='ls --color=auto'"; \
    echo "alias ll='ls --color=auto -alF'"; \
    echo "alias la='ls --color=auto -A'"; \
    echo "alias l='ls --color=auto -CF'"; \
    echo "alias ..='cd ..'"; \
    echo "alias ...='cd ../..'"; \
    echo "alias ....='cd ../../..'"; \
} >> ~/.bashrc

# supervisor
RUN mkdir -p /etc/supervisor.d
ADD .shared/config/etc/supervisord.conf /etc/supervisord.conf

# ssh
COPY .shared/config/etc/ssh/ssh_config /etc/ssh/ssh_config

# start
ADD .shared/scripts/functions.sh /functions.sh
ADD .shared/scripts/docker.sh /docker.sh
ADD .shared/scripts/github.sh /github.sh

RUN chmod +x /functions.sh
RUN chmod +x /docker.sh
RUN chmod +x /github.sh

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
