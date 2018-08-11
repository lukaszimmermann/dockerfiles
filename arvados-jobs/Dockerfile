FROM python:2.7.15-alpine3.8
LABEL maintainer="luk.zim91@gmail.com"

WORKDIR /tmp
RUN apk update --no-cache -U && \
    apk add --no-cache -U --virtual .builddeps \
      curl-dev \
      gcc \
      git \
      linux-headers \
      libxml2-dev \
      libxslt-dev \
      musl-dev && \
    pip install --no-cache-dir -U arvados-python-client && \
    pip install --no-cache-dir -U arvados-cwl-runner && \
    addgroup -S crunch && \
    adduser -g 'Crunch execution user' -DSs /bin/sh -h /home/crunch -G crunch crunch && \
    apk del --purge .builddeps && \
    rm -rf /tmp/* /var/tmp/* && \
    mkdir -p /keep /tmp/crunch-src /tmp/crunch-job /home/crunch && \
    chown -R crunch:crunch /keep /tmp/crunch-src /tmp/crunch-job /home/crunch && \
    chmod -R 0700 /tmp/crunch-src /tmp/crunch-job
USER crunch

