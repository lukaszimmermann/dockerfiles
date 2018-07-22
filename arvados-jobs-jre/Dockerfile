FROM arvados/jobs:latest

USER root
RUN echo deb http://http.debian.net/debian jessie-backports main >> /etc/apt/sources.list && \
    apt-get update -y && \
    apt-get install -t jessie-backports --no-install-recommends --no-install-suggests -y \
        openjdk-8-jre && \
    update-alternatives --config java
USER crunch

