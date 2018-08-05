FROM python:2.7.15-alpine3.8
LABEL maintainer="luk.zim91@gmail.com"

WORKDIR /tmp
RUN apk update --no-cache -U && \
    apk add --no-cache -U --virtual .builddeps \
      curl-dev \
      gcc \
      git \
      musl-dev && \
    pip install --no-cache-dir -U arvados-python-client && \
    pip install --no-cache-dir -U arvados-cwl-runner && \
    addgroup -S crunch && \
    adduser -g 'Crunch execution user' -DHSs /bin/sh -G crunch crunch && \
    apk del --purge .builddeps && \
    rm -rf /tmp/* /var/tmp/* && \
    mkdir -p /keep /tmp/crunch-src /tmp/crunch-job && \
    chown -R crunch:crunch /keep /tmp/crunch-src /tmp/crunch-job && \
    chmod -R 0700 /tmp/crunch-src /tmp/crunch-job
USER crunch
