FROM ruby:2.3.7-slim-stretch
LABEL maintainer="luk.zim91@gmail.com"

# Change the workdir to /tmp, so all temporary files will be deleted at
# the end of the next RUN instruction
WORKDIR /tmp

# We need to do the following things for all Arvados related serviced
# 1. Install the packages dirmngr and gnupg2 for adding the package key
# 2. Install the packages that are the dependencies of arvados-sso-server and
#    arvados-api-server (nginx-light and libpq-dev)
# 3. Install bundler gem
# 4.. Add the key
# 5. Add the Arvados package repository
# 6. Update the package index and clear all temporary files
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends --no-install-suggests \
       dirmngr \
       gnupg2 \
       nginx-light \
       libpq-dev && \
    gem install bundler && \
    /usr/bin/apt-key adv --keyserver pool.sks-keyservers.net --recv 1078ECD7 && \
    echo "deb http://apt.arvados.org/ stretch main" | tee /etc/apt/sources.list.d/arvados.list && \
    apt-get update -y && \
    rm -rf /tmp/* /var/tmp/* && sync
