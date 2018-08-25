FROM ruby:2.3.7-slim-stretch
LABEL maintainer="luk.zim91@gmail.com"

WORKDIR /tmp
RUN gem install bundler && \
    rm -rf /tmp/* /var/tmp/* && sync
