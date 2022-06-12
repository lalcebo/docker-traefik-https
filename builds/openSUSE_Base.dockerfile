FROM opensuse/leap:latest

LABEL maintainer="Jorge P. Hernandez Lalcebo <lalcebo2003@gmail.com>"
LABEL org.opencontainers.image.source="https://github.com/lalcebo/docker-traefik-https"

ARG NODEJS_VERSION=16

RUN zypper --non-interactive refresh \
    # Update and install packages
    && zypper up -y && zypper --non-interactive install \
       # General
       python3-pip libssh2-1 unzip iputils iproute2 hostname \
       w3m nano \
       # NodeJs
       npm${NODEJS_VERSION} \
    # PIP Update and supervisor
    && pip3 install --upgrade pip \
    && pip3 install supervisor \
    # Clean up the zypper cache and logs.
    && rm -rf /var/cache/zypp /var/log/zypp /var/log/zypper.log

# Update .bashrc
RUN { \
    echo "alias ls='ls --color=auto'"; \
    echo "alias ll='ls --color=auto -alF'"; \
    echo "alias la='ls --color=auto -A'"; \
    echo "alias l='ls --color=auto -CF'"; \
    echo "alias ..='cd ..'"; \
    echo "alias ...='cd ../..'"; \
    echo "alias ....='cd ../../..'"; \
} >> ~/.bashrc

# Supervisor
RUN mkdir -p /etc/supervisor.d
ADD .shared/config/etc/supervisord.conf /etc/supervisord.conf

# SSH
COPY .shared/config/etc/ssh/ssh_config /etc/ssh/ssh_config

# Start
ADD .shared/scripts/docker.sh /usr/sbin/docker.sh
RUN chmod +x /usr/sbin/docker.sh

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
