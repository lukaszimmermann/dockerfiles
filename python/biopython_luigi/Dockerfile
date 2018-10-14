FROM python:3.7.0-alpine3.8
LABEL maintainer="luk.zim91@gmail.com"

RUN apk update -U --no-cache && \
    apk add -U --no-cache --virtual .builddeps \
      gcc \
      musl-dev && \
    pip install --no-cache-dir \
      biopython \
      luigi && \
    apk del --purge .builddeps && \
    rm -rf /tmp/* /var/tmp/* && sync

