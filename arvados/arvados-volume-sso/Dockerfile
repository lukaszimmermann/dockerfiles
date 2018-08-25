ARG SSO_PASSWORD
FROM postgres:11-alpine as build
LABEL maintainer="luk.zim91@gmail.com"

# Locale settings
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# This is a tmpdir this image, since the data will be copied to another
# image later
ENV PGDATA /tmp/postgresdata
# su -c "psql -e -d i2b2 -c \"CREATE SCHEMA i2b2imdata AUTHORIZATION i2b2imdata ;\"" postgres && \

WORKDIR /tmp
RUN apk update --no-cache -U && \
    su -c "initdb --username=postgres -D ${PGDATA} --locale=${LANG}" postgres && \
    su -c "pg_ctl -D ${PGDATA} -w -t 10 start" postgres && \
    su -c "psql -e -c \"CREATE ROLE arvados_sso PASSWORD '${PASSWORD}' NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN;\"" postgres && \
    su -c "psql -e -c \"CREATE DATABASE arvados_sso_production OWNER arvados_sso ENCODING 'UTF8' TEMPLATE template0;\"" postgres && \
    su -c "pg_ctl -D ${PGDATA} -w -t 10 -m smart stop" postgres && sync

##################################################
FROM alpine:3.8 as data
COPY --from=build /tmp/postgresdata /opt/data
COPY entrypoint.sh /

ENTRYPOINT [ "/entrypoint.sh" ]
