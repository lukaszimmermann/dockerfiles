FROM phusion/passenger-ruby23:0.9.35
LABEL maintainer="luk.zim91@gmail.com"

WORKDIR /tmp
RUN /usr/bin/apt-key adv --keyserver pool.sks-keyservers.net --recv 1078ECD7 && \
    echo "deb http://apt.arvados.org/ xenial main" | tee /etc/apt/sources.list.d/arvados.list && \
    gem install bundler && \
    cd / && \
    apt-get clean && \
    rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/* && \
    sync
WORKDIR /

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

