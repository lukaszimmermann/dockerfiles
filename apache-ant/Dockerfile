FROM openjdk:8u171-alpine3.8
LABEL maintainer="luk.zim91@gmail.com"

WORKDIR /tmp
RUN apk update --no-cache -U && \
    apk add --no-cache -U wget && \
    wget https://www.i2b2.org/software/projects/installer/apache-ant-1.9.6-bin.zip && \
    unzip apache-ant-1.9.6-bin.zip && \
    rm apache-ant-1.9.6-bin.zip && \
    mkdir -p /usr/local/ant/bin && \
    mv /tmp/apache-ant-1.9.6/bin/ant /usr/local/ant/bin && \
    mv /tmp/apache-ant-1.9.6/etc /usr/local/ant/ && \
    mv /tmp/apache-ant-1.9.6/lib /usr/local/ant/ && \
    apk del --purge wget && \
    rm -rf /tmp/* /var/tmp/*
ENV ANT_HOME /usr/local/ant
ENV PATH "/usr/local/ant/bin:${PATH}"
