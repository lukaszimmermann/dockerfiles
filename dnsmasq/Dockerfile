FROM alpine:3.8
LABEL maintainer="luk.zim91@gmail.com"

RUN apk --no-cache add dnsmasq && rm -rf /var/tmp/* /tmp/* && sync
EXPOSE 53 53/udp
ENTRYPOINT ["dnsmasq", "-k"]

