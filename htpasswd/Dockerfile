FROM alpine:latest
SHELL ["/bin/sh", "-eu", "-c"]
RUN apk update -U --no-cache && \
    apk add -U --no-cache \
      apache2-utils && \
    rm -rf /tmp/* /var/tmp/* && sync
ENTRYPOINT ["htpasswd"]

