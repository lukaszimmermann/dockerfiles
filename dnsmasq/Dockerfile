FROM alpine:3.8
LABEL maintainer="luk.zim91@gmail.com"

RUN apk update --no-cache -U && \
    apk --no-cache -U add dnsmasq  && \
    echo "TAGME=$(dnsmasq --version | grep -Eio 'Dnsmasq\s+version\s+[0-9]+(\.[0-9]+)' | grep -Eo '[0-9]+(\.[0-9]+)')" && \
    rm -rf /var/tmp/* /tmp/* && sync

EXPOSE 53 53/udp
ENTRYPOINT ["dnsmasq", "-k"]

