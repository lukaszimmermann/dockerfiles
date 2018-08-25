FROM lukaszimmermann/arvados-parent:latest
LABEL maintainer="luk.zim91@gmail.com"

COPY entrypoint.sh /opt/entrypoint.sh
RUN  chmod +x /opt/entrypoint.sh && \
     apt-get update -y && \
     apt-get install -y --no-install-recommends --no-install-suggests \
       make && \
     apt-get install -y --no-install-recommends --no-install-suggests \
       gcc \
       g++ \
       libsqlite3-dev \
       ruby2.3-dev && \
     apt-get install -y --no-install-recommends --no-install-suggests \
       arvados-sso-server && \
     apt-get purge -y \
       make \
       gcc \
       g++ \
       libsqlite3-dev \
       ruby2.3-dev && \
      apt-get --purge -y autoremove && \
      apt-get clean -y && \
      apt-get autoclean -y && \
      rm -rf /tmp/* /var/tmp/*
ENTRYPOINT [ "/opt/entrypoint.sh" ]
