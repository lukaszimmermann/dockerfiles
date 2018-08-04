FROM python:3.7.0-alpine3.8
LABEL maintainer="luk.zim91@gmail.com"

ENV RELEASE 2.6.0

WORKDIR /tmp
RUN apk update --no-cache -U && \
    apk add --no-cache -U --virtual .builddeps \
      gcc \
      libarchive-dev \
      linux-headers \
      make \
      musl-dev \
      tar && \
    apk add --no-cache -U bash squashfs-tools && \
    wget "https://github.com/singularityware/singularity/releases/download/2.6.0/singularity-${RELEASE}.tar.gz" && \
    tar xf "singularity-${RELEASE}.tar.gz" && sync && \
    rm "singularity-${RELEASE}.tar.gz" && \
    cd "/tmp/singularity-${RELEASE}" && \
    ./configure --prefix=/usr && make && make install && \
    apk del --no-cache -U --purge .builddeps && \
    rm -rf /tmp/* /var/tmp/* && sync
ENTRYPOINT [ "singularity" ]
