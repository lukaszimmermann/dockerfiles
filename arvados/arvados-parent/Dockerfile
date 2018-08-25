FROM debian:stretch-slim
LABEL maintainer="luk.zim91@gmail.com"

# Change the workdir to /tmp, so all temporary files will be deleted at
# the end of the next RUN instruction
WORKDIR /tmp

# We need to do the following things for all Arvados related serviced
# 0. Install the locales that we need for the database
# 1. Install the packages dirmngr and gnupg2 for adding the package key
# 2. Install the packages that are the dependencies of arvados-sso-server and
#    arvados-api-server (nginx-light and libpq-dev)
# 3. Install bundler gem
# 4. Add the key
# 5. Add the Arvados package repository
# 6. Update the package index and clear all temporary files
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends --no-install-suggests \
      apt-utils && \
    apt-get update -y && \
    apt-get install -y --no-install-recommends --no-install-suggests \
      locales && \
    echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen && sync && \
    locale-gen && sync &&  \
    apt-get update -y && \
    apt-get install -y --no-install-recommends --no-install-suggests \
      dirmngr \
      gnupg2 && \
    /usr/bin/apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7 && \
    apt-get update -y && \
    apt-get install -y --no-install-recommends --no-install-suggests \
       apt-transport-https \
       ca-certificates && \
    echo 'deb https://oss-binaries.phusionpassenger.com/apt/passenger stretch main' > /etc/apt/sources.list.d/passenger.list && sync && \
    apt-get update -y && \
    apt-get install -y --no-install-recommends --no-install-suggests \
       libnginx-mod-http-passenger \
       nginx-light \
       libpq-dev && \
    gem install bundler && \
    /usr/bin/apt-key adv --keyserver pool.sks-keyservers.net --recv 1078ECD7 && \
    echo "deb http://apt.arvados.org/ stretch main" | tee /etc/apt/sources.list.d/arvados.list && \
    apt-get update -y && \
    rm -rf /tmp/* /var/tmp/* && sync

# Set the locale
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LC_ALL en_US.UTF-8
