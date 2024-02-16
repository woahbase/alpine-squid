# syntax=docker/dockerfile:1
#
ARG IMAGEBASE=frommakefile
#
FROM ${IMAGEBASE}
#
RUN set -xe \
    && apk add --no-cache --purge -uU \
#       --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
        apache2-utils \
        squid \
    && mkdir -p /defaults/squid.defaults \
    && mv /etc/squid/* /defaults/squid.defaults \
    && rm -rf /var/cache/apk/* /tmp/*
#
COPY root/ /
#
ENV \
    S6_USER=squid \
    S6_USERHOME=/var/cache/squid
#
VOLUME /var/cache/squid/ /etc/squid/
#
EXPOSE 3128 3129 3130
#
HEALTHCHECK \
    --interval=2m \
    --retries=5 \
    --start-period=5m \
    --timeout=10s \
    CMD \
    squidclient --ping -g 3 -I 1 || exit 1
#
ENTRYPOINT ["/init"]
