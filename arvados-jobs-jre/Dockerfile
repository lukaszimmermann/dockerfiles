FROM lukaszimmermann/arvados-jobs:alpine3.8
LABEL maintainer="luk.zim91@gmail.com"

USER root
RUN apk update --no-cache -U && \
    apk add --no-cache -U \
     openjdk8-jre-base
USER crunch
